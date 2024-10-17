-- ~/.config/nvim/lua/configs/telescope.lua
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("Telescope failed to load", vim.log.levels.ERROR)
  return
end

local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
      },
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
    },
    buffers = {
      theme = "dropdown",
    },
    live_grep = {
      theme = "ivy",
    },
  },
  extensions = {
    -- Add extensions here if they are part of your general setup
  },
})

-- Safe extension loading
local function load_extension_safe(extension)
  local ok, _ = pcall(telescope.load_extension, extension)
  if not ok then
    vim.notify("Failed to load Telescope extension: " .. extension, vim.log.levels.WARN)
  end
end

-- Optionally load some extensions here if you want them by default
load_extension_safe('fzf')
load_extension_safe('zoxide')
load_extension_safe('ui-select')

return telescope

