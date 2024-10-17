return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 900,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        term_colors = true,
        integrations = {
          nvimtree = true,
          gitsigns = true,
          indent_blankline = true,
        },
      })
      local ok, _ = pcall(vim.cmd, "colorscheme catppuccin")
      if not ok then
        vim.notify("Failed to load Catppuccin theme", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 900,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
      })
      local ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
      if not ok then
        vim.notify("Failed to load Tokyo Night theme", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "navarasu/onedark.nvim",
    name = "onedark",
    lazy = false,
    priority = 900,
    config = function()
      require("onedark").setup({
        style = 'deep',
        transparent = true,
      })
      local ok, _ = pcall(vim.cmd, "colorscheme onedark")
      if not ok then
        vim.notify("Failed to load OneDark theme", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "sainnhe/gruvbox-material",
    name = "gruvbox-material",
    lazy = true,
    priority = 900,
    config = function()
      vim.g.gruvbox_material_background = 'medium'
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_transparent_background = 1
      local ok, _ = pcall(vim.cmd, "colorscheme gruvbox-material")
      if not ok then
        vim.notify("Failed to load Gruvbox Material theme", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    lazy = true,
    priority = 900,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
          styles = {
            comments = "italic",
            keywords = "bold",
          },
        },
        integrations = {
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
        },
      })
      local ok, _ = pcall(vim.cmd, "colorscheme nightfox")
      if not ok then
        vim.notify("Failed to load Nightfox theme", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "shaunsingh/nord.nvim",
    name = "true",
    lazy = false,
    priority = 900,
    config = function()
      vim.g.nord_transparent = true
      vim.cmd("colorscheme nord")
    end,
  },
  {
    "marko-cerovac/material.nvim",
    name = "material",
    lazy = true,
    priority = 900,
    config = function()
      require("material").setup({
        contrast = {
          sidebars = true,
          floating_windows = true,
        },
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
        },
        disable = {
          background = true,
        },
      })
      local ok, _ = pcall(vim.cmd, "colorscheme material")
      if not ok then
        vim.notify("Failed to load Material theme", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    lazy = true,
    priority = 1000,
    config = function()
      require("dracula").setup({
        transparent_bg = true,
      })
      local ok, _ = pcall(vim.cmd, "colorscheme dracula")
      if not ok then
        vim.notify("Failed to load Dracula theme", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github_dark",
    lazy = true,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = true,
        },
      })
      local ok, _ = pcall(vim.cmd, "colorscheme github_dark")
      if not ok then
        vim.notify("Failed to load GitHub Dark theme", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    name = "onedarkpro",
    lazy = true,
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        dark_theme = "onedark_vivid",
        options = {
          transparency = true,
        },
      })
      local ok, _ = pcall(vim.cmd, "colorscheme onedark_vivid")
      if not ok then
        vim.notify("Failed to load OneDarkPro theme", vim.log.levels.ERROR)
      end
    end,
  },
}

