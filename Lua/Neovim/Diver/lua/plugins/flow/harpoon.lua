return {
    "ThePrimeagen/harpoon",
    lazy = true,
    keys = {
        -- Add current file to Harpoon marks
        { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>",               mode = "n", desc = "Add current file to Harpoon marks" },
        -- In normal mode, press 'Space' + 'h' + 'a' to add the current file to Harpoon marks.

        -- Open Harpoon quick menu
        { "<leader>hm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",        mode = "n", desc = "Open Harpoon quick menu" },
        -- In normal mode, press 'Space' + 'h' + 'm' to open the Harpoon quick menu.

        -- Navigate to specific Harpoon mark (e.g., mark 1, 2, 3, etc.)
        { "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>",                mode = "n", desc = "Navigate to Harpoon mark 1" },
        -- In normal mode, press 'Space' + 'h' + '1' to navigate to Harpoon mark 1.

        { "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>",                mode = "n", desc = "Navigate to Harpoon mark 2" },
        -- In normal mode, press 'Space' + 'h' + '2' to navigate to Harpoon mark 2.

        { "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>",                mode = "n", desc = "Navigate to Harpoon mark 3" },
        -- In normal mode, press 'Space' + 'h' + '3' to navigate to Harpoon mark 3.

        { "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>",                mode = "n", desc = "Navigate to Harpoon mark 4" },
        -- In normal mode, press 'Space' + 'h' + '4' to navigate to Harpoon mark 4.

        -- Cycle through Harpoon marks forward
        { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<CR>",                 mode = "n", desc = "Navigate to next Harpoon mark" },
        -- In normal mode, press 'Space' + 'h' + 'n' to navigate to the next Harpoon mark.

        -- Cycle through Harpoon marks backward
        { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>",                 mode = "n", desc = "Navigate to previous Harpoon mark" },
        -- In normal mode, press 'Space' + 'h' + 'p' to navigate to the previous Harpoon mark.

        -- Open terminal window associated with Harpoon (e.g., terminal 1)
        { "<leader>ht", "<cmd>lua require('harpoon.term').gotoTerminal(1)<CR>",          mode = "n", desc = "Navigate to Harpoon terminal 1" },
        -- In normal mode, press 'Space' + 'h' + 't' to navigate to Harpoon terminal 1.

        -- Send command to Harpoon terminal 1
        { "<leader>hc", "<cmd>lua require('harpoon.term').sendCommand(1, 'ls -La')<CR>", mode = "n", desc = "Send command to Harpoon terminal 1" },
        -- In normal mode, press 'Space' + 'h' + 'c' to send 'ls -La' command to Harpoon terminal 1.
    },
    config = function()
        require("harpoon").setup {
            global_settings = {
                save_on_toggle = true, -- Saves marks when toggling the UI
                save_on_change = true, -- Automatically saves changes to marks
                enter_on_sendcmd = true, -- Automatically enters terminal commands
                tmux_autoclose_windows = true, -- Close tmux windows on exit
                excluded_filetypes = { "harpoon" }, -- Prevent specific filetypes from being added to Harpoon
                mark_branch = true, -- Enable per-Git branch mark storage
                tabline = true, -- Enable Harpoon marks in the tabline
                tabline_prefix = "  ", -- Custom tabline prefix
                tabline_suffix = "  ", -- Custom tabline suffix
            },
            menu = {
                width = vim.api.nvim_win_get_width(0) - 10, -- Dynamic width of the Harpoon menu
            },
            projects = {
                ["$HOME/Forge/project-a"] = {
                    term = {
                        cmds = {
                            "./start-server.sh", -- Command to run a server
                            "npm run watch", -- Watching for file changes
                        },
                    },
                },
                ["$HOME/Forge/client-project"] = {
                    term = {
                        cmds = {
                            "make build",
                            "docker-compose up",
                        },
                    },
                },
            },
        }
    end,
}
