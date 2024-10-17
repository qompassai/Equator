return {
    "vim-scripts/LargeFile",
    lazy = true,
    config = function()
        vim.g.LargeFile = 10 -- Set the threshold for large files (in MB)
    end,
}
