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
      require("telescope").load_extension("zoxide")
    end,
    lazy = false
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
  lazy = false
  },

  {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup()
  end,
  lazy = false
  },

  {
  "goerz/jupytext.vim",
  lazy = false,
  ft = {"ipynb"}
  },

  {
  "tpope/vim-fugitive",
  lazy = false,
  cmd = {"G", "Git"},
  },

  {
  "bfrg/vim-cuda-syntax",
  lazy = false,
  ft = {"cuda"}
  },

  {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false
  },

  {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Shell
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.code_actions.shellcheck,

        -- Dockerfile/Containerfile
        null_ls.builtins.diagnostics.hadolint,

        -- Lua
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.luacheck,

        -- Ruby
        null_ls.builtins.formatting.rubocop,
        null_ls.builtins.diagnostics.rubocop,

        -- Java
        null_ls.builtins.diagnostics.checkstyle.with({
          extra_args = { "-c", "/google_checks.xml" }, -- Adjust path as needed
        }),

        -- JavaScript/TypeScript
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.prettier,

        -- Jupyter Notebooks
        null_ls.builtins.diagnostics.flake8,  -- For Python in notebooks
        null_ls.builtins.formatting.black,    -- For Python in notebooks

        -- Rust
        null_ls.builtins.formatting.rustfmt,

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
    })
  end,
  lazy = false
},

  {
  "David-Kunz/gen.nvim",
  lazy = false,
  cmd = { "Gen" },  -- Lazy load on command
  keys = {
    { "<leader>g", ":Gen<CR>", desc = "Generate with Gen.nvim" },  -- Lazy load on keybinding
  },
  opts = {
    model = "codellama", -- The default model to use.
    display_mode = "float", -- The display mode. Can be "float" or "split".
    show_prompt = false, -- Shows the Prompt submitted to Ollama.
    show_model = false, -- Displays which model you are using at the beginning of your chat session.
    no_auto_close = false, -- Never closes the window automatically.
  },
  config = function(_, opts)
    require("gen").setup(opts)
    -- Initialize Ollama
    pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
  end,
},
  {
  "vim-scripts/LargeFile",
  lazy = false,
  config = function()
    vim.g.LargeFile = 10  -- in MB
  end
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
    vim.api.nvim_set_keymap("n", "<leader>jl", "<cmd>ToggleTerm direction=float<CR>jupyter lab<CR>", {noremap = true, silent = true})
  end,
  lazy = false,
  },

  {
  "Vimjas/vim-python-pep8-indent",
  lazy = false,
  ft = {"python"}
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "nvchad.configs.mason"
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
        "pyright",
        "tsserver",
        "gopls",
        "jdtls",
        "clangd",
        "omnisharp",
        "dockerls",
        "docker_compose_language_service",
        "jsonls",
        "yamlls",
--         "hls",  -- Haskell Language Server
        "matlab_ls",  -- MATLAB Language Server
        "r_language_server",  -- R Language Server
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

      local lspconfig = require("lspconfig")

      -- Existing configurations
      lspconfig.rust_analyzer.setup{}
      lspconfig.solargraph.setup{}
      lspconfig.tsserver.setup{}
      lspconfig.gopls.setup{}
      lspconfig.jdtls.setup{}
      lspconfig.clangd.setup{}
      lspconfig.omnisharp.setup{}
      lspconfig.dockerls.setup{}
      lspconfig.docker_compose_language_service.setup{}
      lspconfig.jsonls.setup{}
      lspconfig.yamlls.setup{}

      -- Python with enhanced support for Jupyter and ML libraries
      lspconfig.pyright.setup{
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
            }
          }
        },
        filetypes = {"python", "jupyter", "ipynb"}
      }

      -- Haskell
      lspconfig.hls.setup{}

      -- Octave/MATLAB
      lspconfig.matlab_ls.setup{}

      -- R
      lspconfig.r_language_server.setup{}

      -- Jupyter Notebook support
      vim.g.jupytext_fmt = 'py'
      vim.g.jupytext_style = 'hydrogen'

      -- Mojo support (experimental)
      lspconfig.efm.setup{
        init_options = {documentFormatting = true},
        filetypes = {"mojo"},
        settings = {
          rootMarkers = {".git/"},
          languages = {
            mojo = {
              {formatCommand = "mojo format -", formatStdin = true}
            }
          }
        }
      }
    end,
  },
  -- Additional plugins for Jupyter support
  {
    "goerz/jupytext.vim",
    lazy = false,
    ft = {"ipynb"}
  },
  {
    "jupyter-vim/jupyter-vim",
    lazy = false,
    ft = {"python", "jupyter", "r", "haskell", "octave", "mojo"}
  },
  -- Add support for SageMath
  {
    "petRUShka/vim-sage",
    lazy = false,
    ft = {"sage"}
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
    lazy = false
  },

  -- file managing , picker etc
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

  -- formatting!
  {
    "stevearc/conform.nvim",
    lazy = false,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "nvchad.configs.mason"
    end,
    lazy = false,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
    end,
    lazy = false,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
        lazy = false,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
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
    init = function()
      require("core.utils").load_mappings("telescope")
    end,
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
    end,
    lazy = false
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

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
    lazy = false
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
    lazy = false
  }
}

