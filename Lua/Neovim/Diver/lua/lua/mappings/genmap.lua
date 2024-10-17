-- genmap.lua - Modular key mappings configuration for Neovim

local map = vim.keymap.set

-- Neovim operates in four "modes": \27[1mNormal\27[0m, \27[1mCommand*\27[0m, \27[1mInsert\27[0m, and \27[1mVisual\27[0m.

-- \27[1mNormal Mode\27[0m: The default mode, used to navigate around your data without changing it directly.
-- \27[1mInsert Mode\27[0m: Allows you to interact with the data in a detailed way, such as typing and editing text.
-- \27[1mVisual Mode\27[0m: Allows you to select parts of the text interactively, like highlighting with a mouse, so you can then manipulate the selection (e.g., copy, delete).
-- \27[1mCommand Mode*\27[0m: Used to execute specific commands from normal mode, such as saving a file, editing with AI tools, or running database queries. or running database queries.

----------------- Insert Mode Mappings -----------------------

-- Move to the beginning of the line while in insert mode
map("i", "<C-b>", "<ESC>^i", { desc = "Move to the beginning of the line" })

-- Move to the end of the line while in insert mode
map("i", "<C-e>", "<End>", { desc = "Move to the end of the line" })

-- Move left by one character while in insert mode
map("i", "<C-h>", "<Left>", { desc = "Move left by one character" })

-- Move right by one character while in insert mode
map("i", "<C-l>", "<Right>", { desc = "Move right by one character" })

-- Move down by one line while in insert mode
map("i", "<C-j>", "<Down>", { desc = "Move down by one line" })

-- Move up by one line while in insert mode
map("i", "<C-k>", "<Up>", { desc = "Move up by one line" })

----------------- Normal Mode Mappings -----------------------

-- Clear search highlights by pressing Escape in normal mode
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlights" })

-- Switch to the window on the left in normal mode
map("n", "<C-h>", "<C-w>h", { desc = "Switch to the window on the left" })

-- Switch to the window on the right in normal mode
map("n", "<C-l>", "<C-w>l", { desc = "Switch to the window on the right" })

-- Switch to the window below in normal mode
map("n", "<C-j>", "<C-w>j", { desc = "Switch to the window below" })

-- Switch to the window above in normal mode
map("n", "<C-k>", "<C-w>k", { desc = "Switch to the window above" })

-- Save the current file by pressing Control + s in normal mode
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save the current file" })

-- Copy the entire file to the system clipboard in normal mode
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy the entire file to the clipboard" })

return {}
