return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return {
        ensure_installed = {
          "lua",
          "python",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
          "yaml",
          "toml",
          "markdown",
          "bash",
          "fish",
          "vim",
          "regex",
          "rust",
          "go",
          "c",
          "cpp",
          "java",
          "kotlin",
          "swift",
          "ruby",
          "php",
          "r",
          "scala",
          "haskell",
          "perl",
          "clojure",
          "erlang",
          "elixir",
          "dart",
          "vue",
          "svelte",
          "tsx",
          "scss",
          "graphql",
          "dockerfile",
          "make",
          "cmake",
          "latex",
          "bibtex",
          "sql",
          "nix",
          "zig",
          "julia",
          "matlab",
          "cuda",
          "glsl",
          "hlsl",
          "wgsl",
          "proto",
          "terraform",
          "hcl",
          "xml",
          "http",
          "jsdoc",
          "comment",
          "git_rebase",
          "gitignore",
          "gitattributes",
          "diff",
        },
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>si",
            node_incremental = "<leader>si",
            scope_incremental = "<leader>ss",
            node_decremental = "<leader>sd",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>sn"] = "@parameter.inner" },
            swap_previous = { ["<leader>sp"] = "@parameter.inner" },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = { ["<leader>nf"] = "@function.outer" },
            goto_previous_start = { ["<leader>pf"] = "@function.outer" },
          },
        },
        playground = {
          enable = true,
          updatetime = 25,
          persist_queries = false,
        },
        fold = {
          enable = true,
        },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require "mappings.navmap"
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v2.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      require("neo-tree").setup {
        filesystem = {
          follow_current_file = true,
          hijack_netrw = true,
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          window = {
            mappings = {
              ["<CR>"] = "open",
              ["l"] = "open", -- Use 'l' to open files
              ["h"] = "close_node", -- Use 'h' to close nodes
              ["P"] = "toggle_preview", -- Toggle preview with 'P'
            },
          },
          preview = {
            enable = true,
            mappings = {
              ["l"] = "open", -- Use 'l' to open the file after previewing
            },
          },
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(args)
              local opts = { noremap = true, silent = true, buffer = args.bufnr }
              vim.keymap.set("n", "l", "open", opts)
              vim.keymap.set("n", "h", "close_node", opts)
              vim.keymap.set("n", "P", "toggle_preview", opts)
            end,
          },
          {
            event = "file_opened",
            handler = function()
              require("neo-tree.command").execute { action = "close" }
            end,
          },
        },
        window = {
          width = 35,
        },
      }

      vim.keymap.set("n", "<leader>nt", ":Neotree toggle<CR>", { noremap = true, silent = true })
    end,
  },
}
--TSBufEnable options
--highlight: Enables syntax highlighting
--indent: Enables indentation
--incremental_selection: Enables incremental selection
--folding: Enables code folding based on the syntax tree
--playground: Enables the Treesitter playground for debugging
--query_linter: Enables the query linter
--refactor.highlight_definitions: Enables highlighting of definitions
--refactor.navigation: Enables navigation features
--refactor.smart_rename: Enables smart renaming
--textobjects.select: Enables text object selection
--textobjects.move: Enables movement between text objects
--textobjects.swap: Enables swapping of text objects
--textobjects.lsp_interop: Enables LSP interoperability for text objects
