local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    html = { "prettierd" },
    -- Add Rust formatter
    rust = { "rustfmt" },
    -- Add Go formatters
    go = { "gofmt", "goimports" },
    -- Add shellharden for shell scripts
    sh = { "shellharden" },
    bash = { "shellharden" },
    zsh = { "shellharden" },
  },

   format_on_save = {
     -- These options will be passed to conform.format()
     timeout_ms = 500,
     lsp_fallback = true,
   },
}

return options

