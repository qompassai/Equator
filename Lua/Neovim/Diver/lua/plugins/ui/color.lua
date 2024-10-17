return
{
  "norcalli/nvim-colorizer.lua",
  lazy = true,
  event = "BufReadPre",
  config = function()
    require('colorizer').setup({
      filetypes = {
        "*",
        css = { css = true },
      },
      user_default_options = {
        names = false, -- Optional: disable color name highlighting (if that's what you want)
      },
    })
  end,
  }
