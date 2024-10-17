return {
    "stevearc/oil.nvim",
    lazy = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        columns = {
            "icon",
            "permissions",
            "size",
        },
        default_file_explorer = true,
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-v>"] = "actions.select_vsplit",
            ["<C-x>"] = "actions.select_split",
            ["<C-t>"] = "actions.select_tab",
            ["<BS>"] = "actions.parent",
            ["q"] = "actions.close",
            ["<C-r>"] = "actions.refresh",
        },
        float = {
            padding = 5,
            max_width = 100,
            max_height = 40,
        },
        view_options = {
            show_hidden = true,
            is_hidden_file = function(name)
    return name:sub(1, 1) == "."
end,

        },
    },
}

