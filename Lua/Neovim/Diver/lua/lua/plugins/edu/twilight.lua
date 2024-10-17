return {
  "folke/twilight.nvim",
  lazy = false,
  opts = {
    dimming = {
      alpha = 0.25, -- amount of dimming
      color = { "Normal", "#ffffff" }, -- foreground from highlight groups or fallback color
      term_bg = "#000000", -- fallback bg color if guibg=NONE
      inactive = false, -- dim other windows when inactive
    },
    context = 10, -- amount of lines to show around the current line
    treesitter = true, -- use treesitter for filetype when available
    expand = { -- nodes to always fully expand with treesitter
      "function",
      "method",
      "table",
      "if_statement",
    },
    exclude = {}, -- filetypes to exclude
  },
}

