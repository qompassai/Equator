return {
  {
    "kndndrj/nvim-projector",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "kndndrj/projector-neotest",
      "nvim-neotest/neotest",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "mfussenegger/nvim-dap",
      "folke/trouble.nvim",
      "nvim-lualine/lualine.nvim",
    },
    config = function()
      require("projector").setup( --[[optional config]])
    end,
  },
  {
    "kndndrj/nvim-dbee",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "dccsillag/magma-nvim",
      "lewis6991/gitsigns.nvim",
      "hrsh7th/nvim-cmp",
      "lervag/vimtex",
      "nvim-lualine/lualine.nvim",
      "mfussenegger/nvim-dap",
    },
    build = function()
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup()
    end,
  },
}
