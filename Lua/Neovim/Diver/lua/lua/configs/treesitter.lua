local M = {}

M.setup = function()
  local vim = vim
  pcall(function()
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
  end)

  -- Import the lsp_signature plugin
  local lsp_signature = require("lsp_signature")

  -- Set up signature help for Lua LSP
  local function on_attach(client, bufnr)
    if client.name == "lua_ls" then
      lsp_signature.on_attach({
        bind = true,
        handler_opts = {
          border = "rounded"
        },
      }, bufnr)
    end

    -- Define additional LSP-related key mappings
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  end

  local options = {
    ensure_installed = {
      "lua", "luadoc", "vim", "vimdoc",
      "python", "rust", "ruby", "typescript", "javascript",
      "go", "java", "c", "cpp", "csharp", "dockerfile",
      "json", "yaml", "haskell", "r", "matlab",
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
        init_selection = "<leader>si",
        node_incremental = "<leader>sn",
        node_decremental = "<leader>sd",
        scope_incremental = "<leader>ss",
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

    -- Attach the signature help when Lua LSP is set up
    on_attach = on_attach,
  }

  return options
end

return M

