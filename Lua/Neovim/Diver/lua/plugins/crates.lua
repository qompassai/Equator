return
{
    'saecki/crates.nvim',
    lazy = false,
    tag = 'stable',
    config = function()
        require('crates').setup()
    end,
}
