-- ~/.config/nvim/lua/plugins/hover.lua

return {
    "lewis6991/hover.nvim",
    lazy = true,
    config = function()
        require("hover").setup({
            init = function()
                -- Require providers
                require("hover.providers.lsp")
                -- Uncomment below if you need additional providers
                -- require('hover.providers.gh')
                -- require('hover.providers.gh_user')
                -- require('hover.providers.jira')
                -- require('hover.providers.dap')
                -- require('hover.providers.fold_preview')
                -- require('hover.providers.diagnostic')
                -- require('hover.providers.man')
                -- require('hover.providers.dictionary')
            end,
            preview_opts = {
                border = 'single'
            },
            preview_window = true,  -- Whether the contents should be moved to a preview window
            title = true,
            mouse_providers = {
                'LSP'
            },
            mouse_delay = 1000
        })

        -- Set a keybinding to trigger hover.nvim functionality (optional)
        vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
    end,
}

