return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  cmd = { "ToggleTerm" },  -- Lazy load when the command is run
  config = function()
    require("toggleterm").setup({
      -- Optional: add settings for terminal size, direction, etc.
      size = 20,
      open_mapping = [[<c-\>]], -- Default open mapping if desired
      direction = "float",
    })

    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Create a function to easily toggle a Jupyter Lab terminal
    keymap("n", "<leader>jl", function()
      require("toggleterm.terminal").Terminal
        :new({ cmd = "jupyter lab", direction = "float" })
        :toggle()
    end, opts)
  end,
}

