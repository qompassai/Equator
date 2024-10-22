-- TLDR on Plugin Management

-- Add "--" ahead of import line (10=0, 25, 29, 33, 37, 42, 89) to disable
-- At minimum, keep core tools enabled.
-- Remove "--" ahead of import line (14, 25, 29, 33, 37, 42, 89) to enable
-- Go to the directory for customizing plugins
-- plugin .lua files set to lazy = true means it is conditionally loaded as needed
-- plugin .lua files set to lazy = false means it is conditionally loaded as needed

return {
  -- AI tools
  -- Use cases: Develop assistance, auto-completion
  {
    import = "plugins.ai",
    cmd = { "LLMComplete", "Gen" },
    ft = { "python", "lua", "markdown", "javascript" },
  },

  -- Cloud tools
  -- Use cases: Remote file management, SSH, GPG, PQC
  { import = "plugins.cloud", event = "BufReadCmd" },

  -- Core tools
  -- Use cases: Core dependencies and utilities (Eagerly loaded for base functionality)
  { import = "plugins.core" },

  -- Data Science tools
  -- Use cases: Data visualization, Jupyter, Quarto, Markdown
  { import = "plugins.data", ft = { "markdown", "jupyter", "quarto", "python", "r" } },

  -- Educational tools
  -- Use cases: Practice coding, learning Vim commands
  { import = "plugins.edu", cmd = { "VimBeGood", "Twilight" } },

  -- Flow tools
  -- Use cases: Debugging, linting, code completion, version control
  { import = "plugins.flow", event = { "InsertEnter", "BufReadPost" } },

  -- Lang tools
  -- Use cases: LSP/Format/Debug/Lint/Snippets/Autocomplete
  {
    import = "plugins.lang",
    ft = {
      "rust",
      "c",
      "cpp",
      "cuda",
      "python",
      "lua",
      "dockerfile",
      "javascript",
      "typescript",
      "go",
      "yaml",
      "toml",
      "zig",
      "markdown",
      "json",
      "java",
      "mojo",
      "r",
      "ruby",
      "sh",
      "bash",
      "zsh",
      "matlab",
      "html",
      "css",
      "scss",
      "nim",
      "solidity",
      "nix",
      "svelte",
      "scala",
      "graphql",
      "vue",
      "haskell",
      "kotlin",
      "elm",
      "dart",
      "elixir",
      "latex",
      "typst",
    },
  },

  -- Navigation tools
  -- Use cases: File and folder navigation with "fuzzy" finding capabilities
  { import = "plugins.nav", keys = { "<leader>f", "gf" }, event = "BufRead" },

  -- UI tools
  -- Use cases: User interface enhancements, status line, themes
  { import = "plugins.ui", event = "VimEnter" },
}
