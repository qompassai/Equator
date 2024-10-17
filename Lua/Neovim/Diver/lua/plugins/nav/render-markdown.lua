return {
    'MeanderingProgrammer/render-markdown.nvim',
    lazy = true,
    ft = { 'markdown', 'md' },
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        -- Configure any specific options here, if needed.
    },
    config = function(_, opts)
        require('render-markdown').setup(opts)
    end,
    cmd = { "RenderMarkdown", "RenderPreview" },
}

