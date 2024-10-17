local map = vim.keymap.set
local bufopts = { noremap = true, silent = true, buffer = true }

-- Nerd Translate Legend:
--
-- 'LSP': Language Server Protocol, a tool that provides intelligent code features
-- 'Rust': A systems programming language that runs blazingly fast and has an adorable crab mascot.
-- 'Cargo': Rust's package manager and build system
-- 'Macro': A way to write code that writes other code in Rust

-- Rustaceanvim mappings (Need to have LSP Support active for full support all mapppings here)

-- Go to declaration of symbol under cursor
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
-- In normal mode, press 'g' + 'D' to jump to the declaration of the symbol under the cursor

-- Go to definition of symbol under cursor
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
-- In normal mode, press 'g' + 'd' to jump to the definition of the symbol under the cursor

-- Show information about symbol under cursor
map("n", "K", vim.lsp.buf.hover, { desc = "Show symbol info" })
-- In normal mode, press 'K' to display information about the symbol under the cursor

-- Go to implementation of symbol under cursor
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
-- In normal mode, press 'g' + 'i' to jump to the implementation of the symbol under the cursor

-- Show function signature help
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help" })
-- In normal mode, press 'Ctrl' + 'k' to display signature help for the current function

-- Go to type definition of symbol under cursor
map("n", "<space>D", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
-- In normal mode, press 'Space' + 'D' to jump to the type definition of the symbol under the cursor

-- Rename symbol under cursor
map("n", "<space>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
-- In normal mode, press 'Space' + 'r' + 'n' to rename the symbol under the cursor

-- Show code actions
map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
-- In normal mode, press 'Space' + 'c' + 'a' to display available code actions

-- Show references of symbol under cursor
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
-- In normal mode, press 'g' + 'r' to display references to the symbol under the cursor

-- Format code
map("n", "<space>f", function() vim.lsp.buf.format { async = true } end, { desc = "Format code" })
-- In normal mode, press 'Space' + 'f' to format the current buffer

-- Show Rust runnables
map("n", "<leader>rr", "<cmd>RustRunnables<CR>", { desc = "Rust Runnables" })
-- In normal mode, press 'Space' + 'r' + 'r' to display Rust runnable items

-- Show Rust debuggables
map("n", "<leader>rd", "<cmd>RustDebuggables<CR>", { desc = "Rust Debuggables" })
-- In normal mode, press 'Space' + 'r' + 'd' to display Rust debuggable items

-- Expand Rust macro
map("n", "<leader>rt", "<cmd>RustExpandMacro<CR>", { desc = "Rust Expand Macro" })
-- In normal mode, press 'Space' + 'r' + 't' to expand the Rust macro under the cursor

-- Open Cargo.toml
map("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", { desc = "Rust Open Cargo" })
-- In normal mode, press 'Space' + 'r' + 'c' to open the Cargo.toml file

-- Go to parent module
map("n", "<leader>rp", "<cmd>RustParentModule<CR>", { desc = "Rust Parent Module" })
-- In normal mode, press 'Space' + 'r' + 'p' to go to the parent module

-- Toggle comment continuation
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
-- In normal mode, press 'Space' + 't' + 'c' to toggle automatic comment continuation

return {}

