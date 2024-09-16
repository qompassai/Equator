local plugins = {
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"rust"},
    opts = function()
      local null_ls = require("null-ls")
      return {
        sources = {
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.diagnostics.rustfmt,
          null_ls.builtins.diagnostics.clippy,
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
}

return plugins
