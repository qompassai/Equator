local M = {}

M.setup = function()
  local lspconfig = require "lspconfig"
  local mason_lspconfig = require "mason-lspconfig"
  local on_attach = require("plugins.configs.lspconfig").on_attach
  local capabilities = require("plugins.configs.lspconfig").capabilities
  require("mason").setup {
    PATH = "prepend",
    ui = {
      border = "rounded",
    },
  }

  mason_lspconfig.setup {
    ensure_installed = {
      "lua_ls",
      "pyright",
      "tsserver",
      "neocmakelsp",
      "gitlab_ci_lint",
      "rust_analyzer",
      -- Add more LSP servers as needed
    },
    automatic_installation = true,
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      lspconfig[server_name].setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end,

    ["lua_ls"] = function()
      lspconfig.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,

    ["rust_analyzer"] = function()
      lspconfig.rust_analyzer.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            checkOnSave = {
              command = "clippy",
            },
            diagnostics = {
              enable = true,
            },
          },
        },
      }
    end,

    -- Add more server-specific configurations as needed
  }
end

return M
