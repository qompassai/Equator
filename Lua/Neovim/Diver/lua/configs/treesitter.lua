local M = {}

M.setup = function()
  local vim = vim
  pcall(function()
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
  end)

  local options = {
    ensure_installed = {
      "lua", "luadoc", "printf", "vim", "vimdoc",
      "python", "rust", "ruby", "typescript", "javascript",
      "go", "java", "c", "cpp", "csharp", "dockerfile",
      "json", "yaml", "haskell", "r", "matlab", "mojo",
      "bash", "markdown", "html", "css", "toml", "regex",
      "query", "comment", "gitignore", "gitcommit"
    },

    highlight = {
      enable = true,
      use_languagetree = true,
    },

    indent = { enable = true },

    -- Additional features
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
        scope_incremental = "<TAB>",
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
    },
  }

  return options
end

return M
