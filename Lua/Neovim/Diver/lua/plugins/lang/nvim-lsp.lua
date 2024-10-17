return {
  "neovim/nvim-lspconfig",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("configs.lspconfig").defaults()
    require("mason").setup()
    require("mason-lspconfig").setup()

    local lspconfig = require "lspconfig"
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.diagnostic.config {
      virtual_text = false,
      signs = true,
      underline = false,
      update_in_insert = true,
      severity_sort = true,
    }

    -- Lua
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = {
            globals = { 'vim', "use", "require", "pcall", "pairs", "ipairs", "error", "assert", "print", "table", "string", "math", "os", "io", "debug", "package", "coroutine", "bit32", "utf8" },
          },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          disable = { "mixed-table-concat", "different-requires" },
        },
      },
    }

    -- TypeScript
    lspconfig.ts_ls.setup {
      capabilities = capabilities,
      filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
    }

    -- Go
    lspconfig.gopls.setup {
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    }

    -- Java
    lspconfig.jdtls.setup { capabilities = capabilities }

    -- C/C++
    lspconfig.clangd.setup {
      capabilities = capabilities,
      cmd = { "clangd", "--background-index" },
    }

    -- C#
    lspconfig.omnisharp.setup { capabilities = capabilities }

    -- Docker
    lspconfig.dockerls.setup { capabilities = capabilities }
    lspconfig.docker_compose_language_service.setup { capabilities = capabilities }

    -- JSON
    lspconfig.jsonls.setup {
      capabilities = capabilities,
      commands = {
        Format = {
          function() vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0}) end
        }
      }
    }

    -- YAML
    lspconfig.yamlls.setup {
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
          },
        },
      }
    }

   -- Python and Jupyter
lspconfig.pyright.setup {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        extraPaths = {
          vim.fn.expand("$HOME/.local/share/jupyter/kernels/python3"),
          vim.fn.expand("$HOME/.local/share/jupyter/kernels/mojo-jupyter-kernel"),
          "/usr/share/jupyter/kernels/python3",
        },
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
  filetypes = { "python", "jupyter", "ipynb", "mojo" },
}

    -- MATLAB
    lspconfig.matlab_ls.setup { capabilities = capabilities }

    -- R
    lspconfig.r_language_server.setup { capabilities = capabilities }

    -- Ruby
    lspconfig.solargraph.setup { capabilities = capabilities }

    -- Markdown
    lspconfig.marksman.setup {
      capabilities = capabilities,
      filetypes = { "markdown", "markdown.mdx" },
      root_dir = lspconfig.util.root_pattern(".git", ".marksman.toml")
    }

    -- Mojo (using efm for formatting)
    lspconfig.efm.setup {
      capabilities = capabilities,
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

    -- Jupyter-specific settings
    vim.g.jupytext_fmt = "py"
    vim.g.jupytext_style = "hydrogen"
  end,
}

