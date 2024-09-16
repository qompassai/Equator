return {
  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "jvgrootveld/telescope-zoxide",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension "zoxide"
    end,
    lazy = false,
  },

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local startify = require "alpha.themes.startify"
      startify.file_icons.provider = "devicons"
      require("alpha").setup(startify.config)
    end,
    lazy = false,
  },

  {
    "nanotee/zoxide.vim",
    lazy = false,
  },

  {
    "jamessan/vim-gnupg",
    event = "BufReadPre",
    config = function()
      vim.g.GPGPreferSymmetric = 1
    end,
    lazy = false,
  },

  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup()
    end,
    lazy = false,
  },

  {
    "tpope/vim-fugitive",
    lazy = false,
    cmd = { "G", "Git" },
  },

  {
    "bfrg/vim-cuda-syntax",
    lazy = false,
    ft = { "cuda" },
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "mfussenegger/nvim-dap",
    config = function() end,
  },

  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
  },

  {
    "jmbuhr/otter.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },

  {
    "mrcjkb/rustaceanvim",
    lazy = false,
    version = "^4",
    ft = { "rust" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "simrat39/rust-tools.nvim",
    },
    config = function()
      local on_attach = function(bufnr)
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end

      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          autoSetHints = true,
          hover_with_actions = true,
          inlay_hints = {
            show_parameter_hints = true,
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

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "rust-lang/rust.vim",
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require "null-ls"
      local mason_null_ls = require "mason-null-ls"
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      mason_null_ls.setup {
        ensure_installed = {
          "hadolint",
          "stylua",
          "rubocop",
          "checkstyle",
          "prettier",
          "black",
          "gofmt",
          "golangci_lint",
          "pylint",
          "mypy",
        },
        automatic_installation = true,
        handlers = {
          function(source_name, methods)
            require("mason-null-ls").default_setup(source_name, methods)
          end,
        },
      }

      null_ls.setup {
        sources = {

          -- Dockerfile/Containerfile
          null_ls.builtins.diagnostics.hadolint,

          -- Lua
          null_ls.builtins.formatting.stylua,

          -- Ruby
          null_ls.builtins.formatting.rubocop,
          null_ls.builtins.diagnostics.rubocop,

          -- Java
          null_ls.builtins.diagnostics.checkstyle.with {
            extra_args = { "-c", "/google_checks.xml" }, -- Adjust path as needed
          },
          null_ls.builtins.formatting.prettier,

          -- Jupyter Notebooks
          null_ls.builtins.formatting.black, -- For Python in notebooks

          -- Go
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.diagnostics.golangci_lint,

          -- Python
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.mypy,

          -- General
          null_ls.builtins.completion.spell,
          null_ls.builtins.code_actions.gitsigns,
        },
        diagnostics_format = "#{m}",
        diagnostics = false, -- This disables diagnostics by default
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }
    end,
    lazy = false,
  },

  {
    "David-Kunz/gen.nvim",
    lazy = false,
    cmd = { "Gen" }, -- Lazy load on command
    keys = {
      { "<leader>g", ":Gen<CR>", desc = "Generate with Gen.nvim" }, -- Lazy load on keybinding
    },
    opts = {
      model = "phi3.5",
      display_mode = "float",
      show_prompt = false,
      show_model = false,
      no_auto_close = false,
    },
    config = function(_, opts)
      require("gen").setup(opts)
      pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
    end,
  },
  {
    "vim-scripts/LargeFile",
    lazy = false,
    config = function()
      vim.g.LargeFile = 10
    end,
  },
  {
    "jamessan/vim-gnupg",
    event = "BufReadPre",
    config = function()
      vim.g.GPGPreferSymmetric = 1
    end,
    lazy = false,
  },

  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>jl",
        "<cmd>ToggleTerm direction=float<CR>jupyter lab<CR>",
        { noremap = true, silent = true }
      )
    end,
    lazy = false,
  },

  {
    "Vimjas/vim-python-pep8-indent",
    lazy = false,
    ft = { "python" },
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "nvchad.configs.mason"
    end,
    lazy = false,
  },

  {
    'huggingface/llm.nvim',
    opts = {
      api_token = nil, -- You'll need to set this to your Hugging Face API token
      model = "bigcode/starcoder2-15b",
      backend = "huggingface",
      url = nil,
      tokens_to_clear = { "<|endoftext|>" },
      request_body = {
        parameters = {
          max_new_tokens = 60,
          temperature = 0.2,
          top_p = 0.95,
        },
      },
      fim = {
        enabled = true,
        prefix = "<fim_prefix>",
        middle = "<fim_middle>",
        suffix = "<fim_suffix>",
      },
      debounce_ms = 150,
      accept_keymap = "<Tab>",
      dismiss_keymap = "<S-Tab>",
      tls_skip_verify_insecure = false,
      lsp = {
        bin_path = nil,
        host = nil,
        port = nil,
        cmd_env = nil,
        version = "0.5.3",
      },
      tokenizer = nil,
      context_window = 1024,
      enable_suggestions_on_startup = true,
      enable_suggestions_on_files = "*",
      disable_url_path_completion = false,
    },
    config = function(_, opts)
      require('llm').setup(opts)
    end,
    lazy = false
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "rust_analyzer",
        "solargraph",
        "salt_ls",
        "pyright",
        "ts_ls",
        "gopls",
        "jdtls",
        "clangd",
        "omnisharp",
        "dockerls",
        "docker_compose_language_service",
        "jsonls",
        "yamlls",
        "matlab_ls",
        "r_language_server",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("nvchad.configs.lspconfig").defaults()

      local lspconfig = require "lspconfig"
      vim.diagnostic.config({
      virtual_text = false,
      signs = false,
      underline = false,
      update_in_insert = false,
      severity_sort = false,
    })
 
    -- Common on_attach function to disable diagnostics for all servers
    local on_attach = function(client, bufnr)
      -- Disable diagnostics for this buffer
      vim.diagnostic.disable(bufnr)
    end

      lspconfig.rust_analyzer.setup {}
      lspconfig.solargraph.setup {}
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
              disable = { "mixed-table-concat", "different-requires" },
            },
          },
        },
      }
      lspconfig.ts_ls.setup {}
      lspconfig.hls.setup {}
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
  },

  {
  "GCBallesteros/jupytext.nvim",
  config = true,
  lazy = false,
  },

  {
  "kiyoon/jupynium.nvim",
  lazy = false,
  build = "pip3 install --user . --break-system-packages ",
  -- If using conda, use this build command instead:
  -- build = "conda run --no-capture-output -n jupynium pip install .",
  dependencies = {
    "rcarriga/nvim-notify",
    "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
  },
  },

  {
    "jupyter-vim/jupyter-vim",
    lazy = false,
    ft = { "python", "jupyter", "r", "haskell", "octave", "mojo" },
  },

  {
    "petRUShka/vim-sage",
    lazy = false,
    ft = { "sage" },
  },

  {
    "NvChad/ui",
    lazy = false,
    build = function()
      dofile(vim.fn.stdpath "data" .. "/lazy/ui/lua/nvchad_feedback.lua")()
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
    lazy = false,
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "nvchad.configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    lazy = false,
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  {
    "stevearc/conform.nvim",
    lazy = false,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
    end,
    lazy = false,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
        lazy = false,
      },

      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "nvchad.configs.cmp"
    end,
    lazy = false,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = function() end,
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
    end,
    lazy = false,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {
      user_default_options = { names = false },
      filetypes = {
        "*",
        "!lazy",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
    lazy = false,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "nvchad.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    lazy = false,
  },
}
