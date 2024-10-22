local lualine_themes = {
  "onedark",
  "tokyonight",
  "gruvbox",
  "nightfox",
  "catppuccin",
  "everforest",
  "nord",
  "dracula",
  "material",
  "monokai",
  "palenight",
  "edge",
  "darkplus",
  "vscode",
  "ayu_dark",
  "carbonfox",
  "moonfly",
  "horizon",
  "dracula",
  "gotham",
  "github_dark",
  "onedarkpro",
  "nightowl",
  "spacecamp",
  "nordfox",
  "halcyon",
  "synthwave84",
  "matrix",
  "vim-monochrome",
  "gruvbox-material-dark-hard",
  "sublimemonokai",
}

local function debounce(func, timeout)
  local debounce_timer = nil

  return function(...)
    local args = { ... }
    if debounce_timer then
      vim.fn.timer_stop(debounce_timer)
    end
    debounce_timer = vim.fn.timer_start(timeout, function()
      func(unpack(args))
    end)
  end
end

local function preview_lualine_theme_with_telescope()
  local themes = lualine_themes
  require("telescope.pickers")
    .new({}, {
      prompt_title = "Select Lualine Theme",
      finder = require("telescope.finders").new_table {
        results = themes,
      },
      sorter = require("telescope.config").values.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"

        local set_lualine_theme = debounce(function(selection)
          if vim.api.nvim_win_is_valid(prompt_bufnr) and selection then
            require("lualine").setup {
              options = {
                theme = selection[1],
              },
            }
            vim.notify("Lualine theme preview: " .. selection[1], vim.log.levels.INFO)
          end
        end, 50)

        map("i", "<CR>", function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            require("lualine").setup {
              options = {
                theme = selection[1],
              },
            }
            vim.notify("Lualine theme switched to: " .. selection[1], vim.log.levels.INFO)
          end
        end)

        map("i", "<Down>", function()
          actions.move_selection_next(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          set_lualine_theme(selection)
        end)

        map("i", "<Up>", function()
          actions.move_selection_previous(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          set_lualine_theme(selection)
        end)

        map("n", "<CR>", function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            require("lualine").setup {
              options = {
                theme = selection[1],
              },
            }
            vim.notify("Lualine theme switched to: " .. selection[1], vim.log.levels.INFO)
          end
        end)

        map("n", "j", function()
          actions.move_selection_next(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          set_lualine_theme(selection)
        end)

        map("n", "k", function()
          actions.move_selection_previous(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          set_lualine_theme(selection)
        end)

        return true
      end,
    })
    :find()
end

_G.preview_lualine_theme_with_telescope = preview_lualine_theme_with_telescope

vim.api.nvim_set_keymap(
  "n",
  "<leader>lt",
  ":lua preview_lualine_theme_with_telescope()<CR>",
  { noremap = true, silent = true, desc = "[l]ualine [t]oggle theme" }
)

return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
      local function os_data()
        local uname = vim.loop.os_uname().sysname
        if uname:match "Linux" then
          local os_release = vim.fn.system "cat /etc/os-release"
          if os_release:match "Arch" then
            return " "
          elseif os_release:match "Ubuntu" then
            return " "
          else
            return " "
          end
        elseif uname:match "Darwin" then
          return "  "
        else
          return " "
        end
      end

      local function datetime()
        return os.date "%Y-%m-%d %H:%M:%S"
      end

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = lualine_themes[1],
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          always_divide_middle = true,
          globalstatus = false,
        },
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              "branch",
              icon = "", -- Git branch icon
            },
            {
              "diff",
              symbols = { added = "  ", modified = "   ", removed = "   " },
              colored = true, -- Enable colored output
            },
            {
              function()
                local tag = vim.fn.system "git describe --tags --abbrev=0 2>/dev/null"
                tag = vim.trim(tag)

                if tag == "" then
                  return ""
                else
                  return "笠 " .. tag
                end
              end,
              cond = function()
                return vim.fn.isdirectory ".git" == 1
              end,
              color = { fg = "#b5bd68", gui = "bold" },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              diagnostics_color = {
                error = { fg = "#e06c75" },
                warn = { fg = "#e5c07b" },
                info = { fg = "#56b6c2" },
                hint = { fg = "#98c379" },
              },
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
              colored = true,
              update_in_insert = true,
              always_visible = true,
            },
          },
          lualine_c = {
            {
              function()
                local filename = vim.fn.expand "%:t"
                local filetype = vim.bo.filetype

                local icon = require("nvim-web-devicons").get_icon(filename, filetype, { default = true })

                return string.format("%s %s", icon, filename)
              end,
              color = {},
            },
            {
              function()
                return vim.fn.expand "%:p"
              end,
              icon = " ",
            },
            {
              function()
                local clients = vim.lsp.get_clients()
                if next(clients) == nil then
                  return ""
                end
                local lsp_names = {}
                for _, client in pairs(clients) do
                  table.insert(lsp_names, " " .. client.name)
                end
                return table.concat(lsp_names, ", ")
              end,
              icon = " ",
            },
            {
              function()
                local wc = vim.fn.wordcount()
                return string.format("%d words, %d chars", wc.words, wc.chars)
              end,
              icon = " ",
            },
          },
          lualine_x = {
            {
              function()
                local file = vim.fn.expand "%:p"
                if file == "" then
                  return ""
                end
                local size = vim.fn.getfsize(file)
                if size < 0 then
                  return ""
                end
                local units = { "B", "KB", "MB", "GB", "TB" }
                local i = 1
                while size > 1024 and i < #units do
                  size = size / 1024
                  i = i + 1
                end
                return string.format("%.1f %s", size, units[i])
              end,
              icon = " ",
            },
            { "searchcount", maxcount = 999, timeout = 500 },
            { "selectioncount" },
          },
          lualine_y = { "progress" },
          lualine_z = { "location", os_data, datetime },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          "aerial",
          "ctrlspace",
          "fern",
          "fugitive",
          "fzf",
          "lazy",
          "man",
          "mason",
          "mundo",
          "neo-tree",
          "nerdtree",
          "nvim-dap-ui",
          "nvim-tree",
          "oil",
          "overseer",
          "quickfix",
          "symbols-outline",
          "toggleterm",
          "trouble",
        },
      }
    end,
  },
}
