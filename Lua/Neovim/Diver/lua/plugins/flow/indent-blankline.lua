return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      -- Set up hooks and configure indent-blankline
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      -- Autocmd to update highlight groups after colorscheme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local colors = {
            catppuccin = "#7DF9FF",
            tokyonight = "#7AA2F7",
            onedark = "#61AFEF",
            gruvbox_material = "#83A598",
            nightfox = "#81A1C1",
          }

          local current_theme = vim.g.colors_name or "default"
          local color = colors[current_theme] or "#7DF9FF"

          vim.api.nvim_set_hl(0, "IblChar", { fg = color })
          vim.api.nvim_set_hl(0, "IblScopeChar", { fg = color })
        end,
      })

      -- Add key mapping to toggle indent lines on and off
      vim.api.nvim_set_keymap('n', '<leader>ti', ':lua require("ibl").toggle()<CR>', { noremap = true, silent = true })
    end,
    lazy = true,
  }
}

