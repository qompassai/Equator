return
{
    'chipsenkbeil/distant.nvim',
    lazy = true,
    branch = 'v0.3',
    config = function()
        require('distant'):setup()
    end
}
