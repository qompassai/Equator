return {
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
        config = function()
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.sh", "*.bash", "*.zsh" },
                callback = function()
                     vim.lsp.buf.format() -- Uncomment if needed
                end,
            })
        end,
    },
  }
