return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return {
        ensure_installed = { "lua", "python", "javascript", "html", "css" },
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
      require("mappings.navmap")
    end,
  },
}

