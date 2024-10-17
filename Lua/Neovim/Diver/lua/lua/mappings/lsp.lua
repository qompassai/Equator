local map = vim.keymap.set
local ensure_installed = require("mappings.ensure_installed")

ensure_installed()

-- LSP specific mappings
local bufopts = { noremap = true, silent = true, buffer = true }
map("n", "gD", vim.lsp.buf.declaration, bufopts)
map("n", "gd", vim.lsp.buf.definition, bufopts)
map("n", "K", vim.lsp.buf.hover, bufopts)
map("n", "gi", vim.lsp.buf.implementation, bufopts)
map("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
map("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
map("n", "<space>rn", vim.lsp.buf.rename, bufopts)
map("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
map("n", "gr", vim.lsp.buf.references, bufopts)
map("n", "<space>f", function()
  vim.lsp.buf.format { async = true }
end, bufopts)

-- LSP diagnostics
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

return {}

