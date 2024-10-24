local Utils = require("avante.utils")

local filetype_map = {
  ["javascriptreact"] = "javascript",
  ["typescriptreact"] = "typescript",
}

---@class AvanteRepoMap
---@field stringify_definitions fun(lang: string, source: string): string
local repo_map_lib = nil

---@class avante.utils.repo_map
local RepoMap = {}

function RepoMap.setup()
  vim.defer_fn(function()
    local ok, core = pcall(require, "avante_repo_map")
    if not ok then
      error("Failed to load avante_repo_map")
      return
    end

    if repo_map_lib == nil then repo_map_lib = core end
  end, 1000)
end

function RepoMap.get_ts_lang(filepath)
  local filetype = vim.filetype.match({ filename = filepath })
  return filetype_map[filetype] or filetype
end

function RepoMap.get_filetype(filepath)
  return vim.filetype.match({ filename = filepath })
end

function RepoMap._build_repo_map(project_root, file_ext)
  local output = {}
  local gitignore_path = project_root .. "/.gitignore"
  local ignore_patterns, negate_patterns = Utils.parse_gitignore(gitignore_path)
  local filepaths = Utils.scan_directory(project_root, ignore_patterns, negate_patterns)

  vim.iter(filepaths):each(function(filepath)
    if not Utils.is_same_file_ext(file_ext, filepath) then return end

    -- Special case for Ollama provider
    local definitions
    if Config.provider == "ollama" then
      -- Run Ollama locally and use its output
      local cmd = "curl --silent --no-buffer -X POST http://localhost:11434/api/chat -d '" .. Utils.file.read_content(filepath) .. "'"
      definitions = vim.fn.systemlist(cmd)
    else
      -- Default behavior for other providers
      definitions = repo_map_lib.stringify_definitions(
        RepoMap.get_ts_lang(filepath),
        Utils.file.read_content(filepath) or ""
      )
    end

    if definitions == "" then return end
    table.insert(output, {
      path = Utils.relative_path(filepath),
      lang = RepoMap.get_filetype(filepath),
      defs = definitions,
    })
  end)

  return output
end

local cache = {}

function RepoMap.get_repo_map(file_ext)
  local repo_map = RepoMap._get_repo_map(file_ext) or {}
  if not repo_map or next(repo_map) == nil then
    Utils.warn("The repo map is empty. Maybe do not support this language: " .. file_ext)
  end
  return repo_map
end

function RepoMap._get_repo_map(file_ext)
  file_ext = file_ext or vim.fn.expand("%:e")
  local project_root = Utils.root.get()
  local cache_key = project_root .. "." .. file_ext
  local cached = cache[cache_key]
  if cached then return cached end

  local PPath = require("plenary.path")
  local Path = require("avante.path")
  local repo_map

  local function build_and_save()
    repo_map = RepoMap._build_repo_map(project_root, file_ext)
    cache[cache_key] = repo_map
    Path.repo_map.save(project_root, file_ext, repo_map)
  end

  repo_map = Path.repo_map.load(project_root, file_ext)

  if not repo_map or next(repo_map) == nil then
    build_and_save()
    if not repo_map then return end
  else
    local timer = vim.loop.new_timer()

    if timer then
      timer:start(
        0,
        0,
        vim.schedule_wrap(function()
          build_and_save()
          timer:close()
        end)
      )
    end
  end

  local update_repo_map = vim.schedule_wrap(function(rel_filepath)
    if rel_filepath and Utils.is_same_file_ext(file_ext, rel_filepath) then
      local abs_filepath = PPath:new(project_root):joinpath(rel_filepath):absolute()
      local definitions

      -- Special handling for Ollama
      if Config.provider == "ollama" then
        local cmd = "curl --silent --no-buffer -X POST http://localhost:11434/api/chat -d '" .. Utils.file.read_content(abs_filepath) .. "'"
        definitions = vim.fn.systemlist(cmd)
      else
        definitions = repo_map_lib.stringify_definitions(
          RepoMap.get_ts_lang(abs_filepath),
          Utils.file.read_content(abs_filepath) or ""
        )
      end

      if definitions == "" then return end
      local found = false
      for _, m in ipairs(repo_map) do
        if m.path == rel_filepath then
          m.defs = definitions
          found = true
          break
        end
      end
      if not found then
        table.insert(repo_map, {
          path = Utils.relative_path(abs_filepath),
          lang = RepoMap.get_filetype(abs_filepath),
          defs = definitions,
        })
      end
      cache[cache_key] = repo_map
      Path.repo_map.save(project_root, file_ext, repo_map)
    end
  end)

  local handle = vim.loop.new_fs_event()

  if handle then
    handle:start(project_root, { recursive = true }, function(err, rel_filepath)
      if err then
        print("Error watching directory " .. project_root .. ":", err)
        return
      end

      if rel_filepath then update_repo_map(rel_filepath) end
    end)
  end

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    callback = function(ev)
      vim.defer_fn(function()
        local filepath = vim.api.nvim_buf_get_name(ev.buf)
        if not vim.startswith(filepath, project_root) then return end
        local rel_filepath = Utils.relative_path(filepath)
        update_repo_map(rel_filepath)
      end, 0)
    end,
  })

  return repo_map
end

return RepoMap

