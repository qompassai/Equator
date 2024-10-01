return {
    {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "simrat39/rust-tools.nvim",
      {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
    lazy = false
  },
      "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
    tag = 'stable',
    config = function()
        require('crates').setup()
        end,

    },
    config = function()
      local on_attach = function(bufnr)
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end

      vim.g.rustaceanvim = {
        tools = {
          autoSetHints = false,
          hover_with_actions = false,
          inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
        -- LSP configuration
        server = {
          on_attach = on_attach,
          settings = {
            ["rust-analyzer"] = {
              assist = {
                importGranularity = "module",
                importPrefix = "self",
              },
              cargo = {
                loadOutDirsFromCheck = true,
              },
              procMacro = {
                enable = true,
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
        -- DAP configuration
        dap = {
          adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_lldb",
          },
        },
      }

      -- Set up formatting on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        callback = function()
          vim.lsp.buf.format { async = false }
        end,
      })
    end,
  },
 }
