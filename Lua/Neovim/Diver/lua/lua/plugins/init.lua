return {
  -- Load core plugins first without lazy loading as they are ESSENTIAL
  { import = "plugins.core" },   -- Core dependencies and utilities (eagerly loaded)

  -- AI tools, lazy-loaded based on specific commands or filetypes
  { import = "plugins.ai", cmd = { "LLMComplete", "Gen" }, ft = { "python", "lua", "markdown" } },

  -- Cloud-related integrations lazy-loaded when accessing remote files
  { import = "plugins.cloud", event = "BufReadCmd" },

  -- Data handling tools lazy-loaded for specific filetypes like Jupyter, Markdown, etc.
  { import = "plugins.data", ft = { "markdown", "jupyter", "quarto", "python" } },

  -- Educational plugins lazy-loaded based on specific commands
  { import = "plugins.edu", cmd = { "VimBeGood", "Twilight" } },

  -- Flow tools lazy-loaded when insert mode is entered or after buffer read
  { import = "plugins.flow", event = { "InsertEnter", "BufReadPost" } },

  -- Language-specific plugins lazy-loaded based on filetypes
  { import = "plugins.lang", ft = { "rust", "c", "cpp", "cuda" } },

  -- Navigation enhancements lazy-loaded when navigation commands are triggered
  { import = "plugins.nav", keys = { "<leader>f", "gf" }, event = "BufRead" },

  -- UI configurations lazy-loaded on VimEnter
  { import = "plugins.ui", event = "VimEnter" },
}

