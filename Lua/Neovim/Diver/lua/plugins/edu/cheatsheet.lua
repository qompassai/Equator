return {
  "sudormrfbin/cheatsheet.nvim",
  lazy = false,
  keys = {
    { "<leader>?", "<cmd>Cheatsheet<CR>", desc = "Open Cheatsheet" },
  },
  dependencies = {
    "kndndrj/nvim-dbee",
    "nvim-telescope/telescope.nvim",
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "nvim-treesitter/nvim-treesitter",
    "ThePrimeagen/harpoon",
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
    "lewis6991/gitsigns.nvim",
    "nvim-lualine/lualine.nvim",
    "davidmh/cspell.nvim",
    "gbprod/none-ls-shellcheck.nvim",
    "gbprod/none-ls-luacheck.nvim",
    "gbprod/none-ls-php.nvim",
    "gbprod/none-ls-psalm.nvim",
    "gbprod/none-ls-ecs.nvim",
    "mfussenegger/nvim-dap-python",
    "mrcjkb/rustaceanvim",
    "nvimtools/none-ls-extras.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
    "nvimtools/none-ls.nvim",
    "neovim/nvim-lspconfig",
    "Zeioth/none-ls-external-sources.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-neo-tree/neo-tree.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
    "nvim-lua/plenary.nvim",
    "jvgrootveld/telescope-zoxide",
    "nvim-telescope/telescope-ui-select.nvim",
    "folke/tokyonight.nvim",
    "catppuccin/nvim",
    "gruvbox-community/gruvbox",
    "EdenEast/nightfox.nvim",
    "rose-pine/neovim",
    "stevearc/oil.nvim",
    "stevearc/conform.nvim",
    "akinsho/bufferline.nvim",
    "yetone/avante.nvim",
    "stevearc/dressing.nvim",
    "HakonHarnes/img-clip.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
    "huggingface/llm.nvim",
    "frankroeder/parrot.nvim",
    "folke/noice.nvim",
    "norcalli/nvim-colorizer.lua",
    "tribela/transparent.nvim",
    "nvim-lualine/lualine.nvim",
    "dccsillag/magma-nvim",
    "lewis6991/gitsigns.nvim",
    "hrsh7th/nvim-cmp",
    "lervag/vimtex",
    "arminveres/md-pdf.nvim",
    "quarto-dev/quarto-nvim",
    "jmbuhr/otter.nvim",
    "GCBallesteros/jupytext.nvim",
    "jpalardy/vim-slime",
    "HakonHarnes/img-clip.nvim",
    "jbyuki/nabla.nvim",
    "akinsho/toggleterm.nvim",
    "vim-scripts/LargeFile",
  },
  config = function()
    require("cheatsheet").setup {
      bundled_cheatsheets = true,
      bundled_plugin_cheatsheets = true,
      include_only_installed_plugins = true,
    }
  end,
}