return
{
    "jamessan/vim-gnupg",
    event = "BufReadPre",
    config = function()
      vim.g.GPGPreferSymmetric = 1
    end,
    lazy = true,
  }
