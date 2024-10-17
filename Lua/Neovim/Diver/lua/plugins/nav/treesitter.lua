return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
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

        highlight = {
          enable = true,
        },
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
            swap_next = {
              ["<leader>sn"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>sp"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- Adds jumps in the jumplist
            goto_next_start = {
              ["<leader>nf"] = "@function.outer",
            },
            goto_previous_start = {
              ["<leader>pf"] = "@function.outer",
            },
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
      -- Setup Treesitter configurations using the provided options
      require("nvim-treesitter.configs").setup(opts)

      -- Load the navigation mappings once Treesitter is set up
      require "mappings.navmap"
    end,
  },
}
