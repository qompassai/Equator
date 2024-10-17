-- Define available lualine themes
local lualine_themes = {
  'onedark', 'tokyonight', 'gruvbox', 'nightfox', 'catppuccin', 'everforest',
  'nord', 'dracula', 'material', 'monokai', 'palenight', 'edge', 'darkplus',
  'vscode', 'ayu_dark', 'carbonfox', 'moonfly', 'horizon', 'darcula', 'gotham',
  'github_dark', 'onedarkpro', 'nightowl', 'spacecamp', 'nordfox',
  'halcyon', 'synthwave84', 'matrix', 'vim-monochrome', 'gruvbox-material-dark-hard', 'sublimemonokai'
}

function preview_lualine_theme_with_telescope()
  local themes = lualine_themes
  require('telescope.pickers').new({}, {
    prompt_title = "Select Lualine Theme",
    finder = require('telescope.finders').new_table {
      results = themes,
    },
    sorter = require('telescope.config').values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      map('i', '<CR>', function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          require('lualine').setup {
            options = {
              theme = selection[1],
            }
          }
          vim.notify("Lualine theme switched to: " .. selection[1], vim.log.levels.INFO)
        end
      end)

      map('i', '<Down>', function()
        actions.move_selection_next(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          require('lualine').setup {
            options = {
              theme = selection[1],
            }
          }
        end
      end)

      map('i', '<Up>', function()
        actions.move_selection_previous(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          require('lualine').setup {
            options = {
              theme = selection[1],
            }
          }
        end
      end)

      return true
    end,
  }):find()
end

return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
      local function os_data()
        local uname = vim.loop.os_uname().sysname
        if uname:match("Linux") then
          local os_release = vim.fn.system("cat /etc/os-release")
          if os_release:match("Arch") then
            return " "
          elseif os_release:match("Ubuntu") then
            return " "
          else
            return " "
          end
        elseif uname:match("Darwin") then
          return " "
        else
          return " "
        end
      end

      local function datetime()
        return os.date('%Y-%m-%d %H:%M:%S')
      end

      local function lsp_status()
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then return '' end
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        for _, client in ipairs(clients) do
          if vim.fn.index(client.config.filetypes or {}, buf_ft) ~= -1 then
            return '  ' .. client.name
          end
        end
        return ''
      end


      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = lualine_themes[1], -- Start with the first theme
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            {
              'diff',
              colored = true,
              symbols = { added = ' ', modified = ' ', removed = ' ' }
            },
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              sections = { 'error', 'warn', 'info', 'hint' },
              diagnostics_color = {
                error = { fg = '#e06c75' },
                warn  = { fg = '#e5c07b' },
                info  = { fg = '#56b6c2' },
                hint  = { fg = '#98c379' },
              },
              symbols = {
                error = ' ',
                warn  = ' ',
                info = ' ',
                hint = ' ',
              },
              colored = true,
              update_in_insert = true,
              always_visible = true,
            }
          },
          lualine_c = { 'filename', { 'lsp_progress' } },
          lualine_x = {
  'encoding',
  'fileformat',
  'filetype',
  lsp_status,
  { 'filesize', fmt = function(str) return str:gsub(' ', '') end },
  { 'searchcount', maxcount = 999, timeout = 500 },
  { 'selectioncount' },
},
          lualine_y = { 'progress' },
          lualine_z = { 'location', os_data, datetime }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {
          lualine_a = { 'buffers' },
          lualine_b = { { 'filename', path = 3 } },
          lualine_c = {},
          lualine_x = { 'branch', 'diff' },
          lualine_y = {},
          lualine_z = {}
        },
        winbar = {},
        inactive_winbar = {},
        extensions = { 'quickfix', 'fugitive', 'nvim-tree', 'toggleterm', 'trouble' }
      }
    end,
  },
}

