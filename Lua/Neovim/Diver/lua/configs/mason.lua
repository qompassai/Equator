local M = {}

M.setup = function()
  local lspconfig = require "lspconfig"
  local mason_lspconfig = require "mason-lspconfig"

  mason_lspconfig.setup {
    ensure_installed = {
      "lua_ls",
      "pyright",
      "tsserver",
      -- Add more LSP servers as needed
    },
    automatic_installation = true,
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      lspconfig[server_name].setup {}
    end,

    ["lua_ls"] = function()
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      }
    end,
    -- Add more server-specific configurations as needed
  }
end

return M
