local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Nerd Translate Legend (Alphabetical Order):

-- 'Cargo': Rust's package manager and build system, used for managing dependencies, compiling projects, and running tests.
--   Example: Similar to npm for JavaScript, Cargo helps manage Rust libraries and tools.

-- 'Code Action': Suggestions provided by LSP to refactor, add missing imports, or fix code issues.
--   Example: Like spellcheck for code; it suggests fixes when you have mistakes.

-- 'Declaration': The place where a symbol is first introduced in the code, defining its type and sometimes initializing it.
--   Example: Declaring a variable like `let x = 5;` introduces `x` in the code.

-- 'Debuggables': In Rust, these are parts of the code that can be debugged, typically requiring special configurations or commands.
--   Example: Think of setting breakpoints to find issues in specific parts of the program.

-- 'Formatting': Automatically adjusts the spacing, indentation, and arrangement of the code for better readability and consistency.
--   Example: Similar to auto-formatting text in a word processor, but for code.

-- 'Implementation': The actual code where a function or method is defined. It differs from a declaration as it contains logic.
--   Example: If you declare a function in a header, its implementation contains the actual steps it performs.

-- 'LSP': Language Server Protocol, a tool that provides intelligent code features like autocompletion, go-to-definition, and diagnostics.
--   Example: Helps your editor understand code better, like suggesting how to finish typing a function name.

-- 'Macro': A way to write code that writes other code in Rust, enabling metaprogramming.
--   Example: Like using a template to generate boilerplate code automatically.

-- 'Module': A file or collection of files that logically group related functions, types, and values in Rust or other languages.
--   Example: Similar to organizing related chapters in a book, modules group related functions.

-- 'References': Shows all occurrences of a symbol across the codebase, helping understand where and how it’s used.
--   Example: Like finding every mention of a character's name in a book to track their appearances.

-- 'Runnables': In Rust, these are units of code that can be executed, such as tests or main functions.
--   Example: A runnable could be a test case that you execute to ensure the code works.

-- 'Rust': A systems programming language that runs blazingly fast and has an adorable crab mascot.
--   Example: Rust is often used for performance-critical applications, like game engines.

-- 'Signature': The part of the code that defines a function's name, parameters, and return type.
--   Example: Like the title of a recipe, showing the name, ingredients, and what it makes.

-- 'Signature Help': Shows the function signature of the function you are currently typing, including parameters and types.
--   Example: Helps you see what inputs a function needs while you’re coding.

-- 'Symbol': A generic term for any named element in the code, such as a function, variable, class, or method.
--   Example: A symbol could be a function name like `print` or a variable like `age`.

-- 'TOML': A file format (`.toml`) used for configuration, particularly in Rust for `Cargo.toml` files that define settings.
--   Example: Like a settings file in a game, TOML helps configure project details.

-- 'Type Definition': Displays the type information of a particular variable or function.
--   Example: Helps you know if a variable is a number, text, or something else.

-- Nvim-LSP go to declaration of symbol under cursor
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", noremap = true, silent = true })
-- In normal mode, press 'g' + 'D' to jump to the declaration of the symbol under the cursor

-- Nvim-LSP go to definition of symbol under cursor
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", noremap = true, silent = true })
-- In normal mode, press 'g' + 'd' to jump to the definition of the symbol under the cursor

-- Nvim-LSP show information about symbol under cursor
map("n", "sh", vim.lsp.buf.hover, { desc = "Nvim-LSP [s]ymbol [h]over info", noremap = true, silent = true })
-- In normal mode, press 's' + 'h' to display information about the symbol under the cursor

-- Nvim-LSP Go to implementation of symbol under cursor
map("n", "gi", vim.lsp.buf.implementation, { desc = "Nvim-LSP Go to implementation", noremap = true, silent = true })
-- In normal mode, press 'g' + 'i' to jump to the implementation of the symbol under the cursor

-- Nvim-LSP show function signature help
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Nvim-LSP show signature help", noremap = true, silent = true })
-- In normal mode, press 'Ctrl' + 'k' to display signature help for the current function

-- Nvim-LSP go to type definition of symbol under cursor
map("n", "<space>D", vim.lsp.buf.type_definition, { desc = "Nvim-LSP go to type definition", noremap = true, silent = true })
-- In normal mode, press 'Space' + 'D' to jump to the type definition of the symbol under the cursor

-- Rename symbol under cursor
map("n", "<space>rn", vim.lsp.buf.rename, { desc = "Rename symbol", noremap = true, silent = true })
-- In normal mode, press 'Space' + 'r' + 'n' to rename the symbol under the cursor

-- Show code actions
map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "Show code actions", noremap = true, silent = true })
-- In normal mode, press 'Space' + 'c' + 'a' to display available code actions

-- Show references of symbol under cursor
map("n", "gr", vim.lsp.buf.references, { desc = "Nvim-LSP Show references", noremap = true, silent = true })
-- In normal mode, press 'g' + 'r' to display references to the symbol under the cursor

-- Format code
map("n", "<space>f", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format code", noremap = true, silent = true })
-- In normal mode, press 'Space' + 'f' to format the current buffer

-- Rustaceanvim mappings

-- Rustaceanvim show Rust runnables
map("n", "<leader>rr", "<cmd>RustRunnables<CR>", { desc = "Rustaceanvim show [r]ust [r]unnables", noremap = true, silent = true })
-- In normal mode, press 'Space' + 'r' + 'r' to display Rust runnable items

-- Show Rust debuggables
map(
  "n",
  "<leader>rd",
  "<cmd>RustDebuggables<CR>",
  { desc = "Rustaceanvim show [r]ust [d]ebuggables", noremap = true, silent = true }
)
-- In normal mode, press 'Space' + 'r' + 'd' to display Rust debuggable items

-- Expand Rust macro
map("n", "<leader>rt", "<cmd>RustExpandMacro<CR>", { desc = "Rustaceanvim expand [r]ust [m]acro", noremap = true, silent = true })
-- In normal mode, press 'Space' + 'r' + 't' to expand the Rust macro under the cursor

-- Open Cargo.toml
map("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", { desc = "Rustaceanvim open [C]argo.toml", noremap = true, silent = true })
-- In normal mode, press 'Space' + 'r' + 'c' to open the Cargo.toml file

-- Rustaceanvim go to parent module
map(
  "n",
  "<leader>rp",
  "<cmd>RustParentModule<CR>",
  { desc = "Rustaceanvim go to parent [m]odule", noremap = true, silent = true }
)
-- In normal mode, press 'Space' + 'r' + 'p' to go to the parent module

-- Rustaceanvim toggle comment continuation
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
end, { desc = "Rustaceanvim toggle [t]oggle [c]omment continuation", noremap = true, silent = true })
-- In normal mode, press 'Space' + 't' + 'c' to toggle automatic comment continuation

return {}
