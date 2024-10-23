local map = vim.keymap.set
local ensure_installed = require "mappings.ensure_installed"

ensure_installed()

-- LSP specific mappings
local bufopts = { noremap = true, silent = true, buffer = true }

-- map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "Go to declaration" }))
-- map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "Go to definition" }))
-- map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "Hover documentation" }))
-- map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "Go to implementation" }))
-- map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", bufopts, { desc = "Show signature help" }))
-- map("n", "<space>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", bufopts, { desc = "Go to type definition" }))
-- map("n", "<space>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename symbol" }))
-- map("n", "<space>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "Show code actions" }))
-- map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "Show references" }))
-- map("n", "<space>f", function()
--   vim.lsp.buf.format { async = true }
-- end, vim.tbl_extend("force", bufopts, { desc = "Format code" }))

-- Diagnostic LSP list
map("n", "<leader>dll", vim.diagnostic.setloclist, { desc = "LSP [d]iagnostic [l]oclist" })
-- In normal mode, press 'space' + 'd' + 'l' + 'l' to open a list of diagnostic suggestions (errors/formatting/safety) to address.
return {}
