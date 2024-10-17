return {
    "lewis6991/gitsigns.nvim",
    lazy = true,  -- Enable lazy loading
    event = { "BufReadPre", "BufNewFile" },
    cond = function()
        -- Only load if the current directory or file is inside a Git repo
        local in_git_repo = vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null')
        return vim.fn.trim(in_git_repo) == "true"
    end,
    opts = function()
        return require("configs.gitsigns").opts
    end,
    config = function(_, opts)
        require('gitsigns').setup(opts)
    end,
}

