return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      spelling = { enabled = true, suggestions = 20 }, -- Enable spelling suggestions
    },
    window = {
      border = "single",  -- Use a single-line border for the which-key window
      position = "bottom", -- Show the which-key window at the bottom of the screen
    },
    layout = {
      align = "center", -- Align the keymaps in the center of the window
    },
    triggers = "auto", -- Automatically trigger which-key for all mappings
  },
  keys = {
    { "<leader>cf", ":TSToggleFold<CR>", desc = "Toggle Folding" },
    { "<leader>nf", ":lua require'nvim-treesitter.textobjects.move'.goto_next_start('@function.outer')<CR>", desc = "TS next function" },
    { "<leader>pf", ":lua require'nvim-treesitter.textobjects.move'.goto_previous_start('@function.outer')<CR>", desc = "TS previous function" },
    { "<leader>sn", ":TSSwapNextParameter<CR>", desc = "Swap with Next Parameter" },
    { "<leader>sp", ":TSSwapPreviousParameter<CR>", desc = "Swap with Previous Parameter" },
    { "<leader>th", ":TSToggleHighlight<CR>", desc = "Toggle Highlighting" },
    { "<leader>tp", ":TSTogglePlayground<CR>", desc = "Toggle Playground" },
    { "<leader>tq", ":TSShowCaptures<CR>", desc = "Show Captures" },
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    local wk = require("which-key")

    -- Optionally register additional mappings if needed
    wk.register({
      -- Add any further mappings or nested keybindings here
    })
  end,
}

