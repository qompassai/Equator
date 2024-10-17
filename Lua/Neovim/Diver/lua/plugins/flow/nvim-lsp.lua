return
{
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("configs.lspconfig").defaults()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local lspconfig = require "lspconfig"
      vim.diagnostic.config {
        virtual_text = false,
        signs = false,
        underline = false,
        update_in_insert = false,
        severity_sort = false,
      }
      lspconfig.rust_analyzer.setup {}
      lspconfig.solargraph.setup {}
      lspconfig.lua_ls.setup {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = {
                'vim',
                "use",
                "require",
                "pcall",
                "pairs",
                "ipairs",
                "error",
                "assert",
                "print",
                "table",
                "string",
                "math",
                "os",
                "io",
                "debug",
                "package",
                "coroutine",
                "bit32",
                "utf8",
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              disable = { "mixed-table-concat", "different-requires" },
            },
          },
        },
      }
      lspconfig.ts_ls.setup {}
      lspconfig.gopls.setup {}
      lspconfig.jdtls.setup {}
      lspconfig.clangd.setup {}
      lspconfig.omnisharp.setup {}
      lspconfig.dockerls.setup {}
      lspconfig.docker_compose_language_service.setup {}
      lspconfig.jsonls.setup {}
      lspconfig.yamlls.setup {}
      lspconfig.pyright.setup {
        settings = {
          python = {
            analysis = {
              extraPaths = {
                "/usr/share/jupyter/kernels/python3",
                "/home/phaedrus/.local/share/jupyter/kernels/mojo-jupyter-kernel",
              },
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
        filetypes = { "python", "jupyter", "ipynb", "mojo" },
      }
      lspconfig.matlab_ls.setup {}
      lspconfig.r_language_server.setup {}
      vim.g.jupytext_fmt = "py"
      vim.g.jupytext_style = "hydrogen"

      lspconfig.efm.setup {
        init_options = { documentFormatting = false },
        filetypes = { "mojo" },
        settings = {
          rootMarkers = { ".git/" },
          languages = {
            mojo = {
              { formatCommand = "mojo format -", formatStdin = true },
            },
          },
        },
      }
    end,
  }

