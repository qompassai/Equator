return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  cmd = { "ToggleTerm" },  -- Lazy load when the command is run
  config = function()
    require("toggleterm").setup({
      -- Optional: add settings for terminal size, direction, etc.
      size = 20,
      open_mapping = [[<c-\>]],
      direction = "float",
    })
  end,
}

