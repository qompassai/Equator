-- plugins for notetaking and knowledge management

return {

  {
    'nvim-neorg/neorg',
    lazy = false,
    enabled = true,
    config = function()
      require('neorg').setup {}
    end,
  },

  {
    'jakewvincent/mkdnflow.nvim',
    lazy = false,
    enabled = true,
    config = function()
      local mkdnflow = require 'mkdnflow'
      mkdnflow.setup {}
    end,
  },
}
