return
    {"nvim-lua/plenary.nvim",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = {"*.sh", "*.bash", "*.zsh", "*rc"},
        callback = function()
          --vim.lsp.buf.format()
        end,
        })
    end,
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "nvchad.configs.mason"
    end,
    lazy = false,
  },
  {
    "NvChad/base46",
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
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
    opts = {}
      },

  {
    "David-Kunz/gen.nvim",
    lazy = false,
    cmd = { "Gen" },
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
    "huggingface/llm.nvim",
    opts = {
      api_token = function()
        return vim.fn.system("pass show hf"):gsub("\n", "")
      end,
      model = "qompass/r3",
      backend = "huggingface",
      url = "https://localhost:3000",
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
      require("llm").setup(opts)
    end,
    lazy = true,
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
        rust = {"rustfmt"},
        go = { "gofmt", "goimports" },
      python = { "black", "isort" },
      ruby = { "rubocop" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd"},
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
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
