local map = vim.keymap.set
local bufopts = { noremap = true, silent = true, buffer = true }

--Rustacean mappings
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
map("n", "<leader>rr", "<cmd>RustRunnables<CR>", { desc = "Rust Runnables" })
map("n", "<leader>rd", "<cmd>RustDebuggables<CR>", { desc = "Rust Debuggables" })
map("n", "<leader>rt", "<cmd>RustExpandMacro<CR>", { desc = "Rust Expand Macro" })
map("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", { desc = "Rust Open Cargo" })
map("n", "<leader>rp", "<cmd>RustParentModule<CR>", { desc = "Rust Parent Module" })
map("n", "gd", vim.lsp.buf.declaration, bufopts)
map("n", "gd", vim.lsp.buf.definition, bufopts)
map("n", "H", vim.lsp.buf.hover, bufopts)
map("n", "gi", vim.lsp.buf.implementation, bufopts)
map("n", "<c-k>", vim.lsp.buf.signature_help, bufopts)
map("n", "<space>d", vim.lsp.buf.type_definition, bufopts)
map("n", "<space>rn", vim.lsp.buf.rename, bufopts)
map("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
map("n", "gr", vim.lsp.buf.references, bufopts)
map("n", "<space>f", function()
  vim.lsp.buf.format { async = true }
end, bufopts)
map("n", "<leader>tc", function()
  local current = vim.opt.formatoptions:get()
  if vim.tbl_contains(current, "c") then
    vim.opt.formatoptions:remove "c"
    vim.opt.formatoptions:remove "r"
    vim.opt.formatoptions:remove "o"
    print "Comment continuation disabled"
  else
    vim.opt.formatoptions:append "c"
    vim.opt.formatoptions:append "r"
    vim.opt.formatoptions:append "o"
    print "Comment continuation enabled"
  end
end, { desc = "Toggle comment continuation" })

return {}

