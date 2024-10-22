-- Import necessary modules
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Nerd Translate Legend:
--
-- 'Alt': The alternate key on your keyboard, usually next to the space bar.
-- 'Buffer': A temporary place to keep an open file. In Neovim buffer=file more or less.
-- 'Ctrl': The control key, usually at the bottom of the keyboard.
-- 'Directory': A digital storage place for your files, aka "folder".
-- 'File': A document or piece of information saved on your computer, like a drawing that you store in a drawer.
-- 'Fuzzy Finding': Search for things your memory's a little "fuzzy" on.
-- 'Grep': A tool to quickly find words or phrases in files. It's like looking through your documents with a magnifying glass to find specific words.
-- 'Leader/Leader key': The 'Space' key, which you press in normal mode before other keys to run commands.
-- 'Mappings': Custom keyboard shortcuts unique to each Diver tool. TLDR: Type less, do more.
-- 'Mark': A virtual bookmark in your text that lets you quickly jump back to important spots in your code or document.
-- 'NvimTree': A file explorer to see all the folders and files in a "tree"-like structure. Think file explorer in Windows.
-- 'Telescope': A free & open-source tool to search and find your data on your computer.
-- 'ToggleTerm': A way to open new windows in your terminal.
-- 'Zoxide': A tool to quickly jump to the places you visit most often.

-- Telescope mappings

-- Telescope: Finds files on your computer
map("n", "<leader>tff", "<cmd>Telescope find_files<CR>", vim.tbl_extend("force", opts, { desc = "Telefind files" }))
-- In normal mode, press 'Space' + 't' + 'f' + 'f' to open Telescope and search for files

-- Telescope: Live searches your computer by word
map("n", "<leader>tls", "<cmd>Telescope live_grep<CR>", vim.tbl_extend("force", opts, { desc = "Telelive search" }))
-- In normal mode, press 'Space' + 't' + 'l' + 's' to search for text across files

-- Telescope: Finds all the open files that you're working on
map("n", "<leader>tfb", "<cmd>Telescope buffers<CR>", vim.tbl_extend("force", opts, { desc = "Telefind buffers" }))
-- In normal mode, press 'Space' + 't' + 'f' + 'b' to open a list of open buffers

-- Telescope: Find help tags using Telescope
map("n", "<leader>tfh", "<cmd>Telescope help_tags<CR>", vim.tbl_extend("force", opts, { desc = "Telefind help" }))
-- In normal mode, press 'Space' + 't' + 'f' + 'h' to search through help documentation

-- Telescope: Find marks
map("n", "<leader>tma", "<cmd>Telescope marks<CR>", vim.tbl_extend("force", opts, { desc = "Telefind marks" }))
-- In normal mode, press 'Space' + 't' + 'm' + 'a' to list marks

-- Telescope: Find old files
map("n", "<leader>tfo", "<cmd>Telescope oldfiles<CR>", vim.tbl_extend("force", opts, { desc = "Telefind oldfiles" }))
-- In normal mode, press 'Space' + 't' + 'f' + 'o' to list recently opened files

-- Telescope: Fuzzy search current file
map("n", "<leader>tfc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", vim.tbl_extend("force", opts, { desc = "Telefind in current buffer" }))
-- In normal mode, press 'Space' + 't' + 'f' + 'c' to search for text in the current buffer

-- Telescope: Find git commits
map("n", "<leader>tgc", "<cmd>Telescope git_commits<CR>", vim.tbl_extend("force", opts, { desc = "Telefind git commits" }))
-- In normal mode, press 'Space' + 't' + 'g' + 'c' to list git commits

-- Telescope: Check git status
map("n", "<leader>tgs", "<cmd>Telescope git_status<CR>", vim.tbl_extend("force", opts, { desc = "Telegit status" }))
-- In normal mode, press 'Space' + 't' + 'g' + 's' to check git status

-- Telescope: Pick hidden terminal
map("n", "<leader>tr", "<cmd>Telescope terms<CR>", vim.tbl_extend("force", opts, { desc = "Telepick hidden term" }))
-- In normal mode, press 'Space' + 't' + 'r' to list hidden terminals

-- Telescope: Finds all hidden & ignored files
map("n", "<leader>tfa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", vim.tbl_extend("force", opts, { desc = "Telefind all files" }))
-- In normal mode, press 'Space' + 't' + 'f' + 'a' to search for all files, even hidden ones

-- NvimTree mappings

-- NvimTree: Toggle NvimTree file explorer window (open or close the file manager window)
map("n", "<leader>nt", "<cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", opts, { desc = "NvimTree toggle window" }))
-- In normal mode, press 'Space' + 'n' + 't' to open or close the NvimTree window

-- NvimTree: Focus the NvimTree file explorer window
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", vim.tbl_extend("force", opts, { desc = "NvimTree focus window" }))
-- In normal mode, press 'Space' + 'e' to focus on the NvimTree window

-- ToggleTerm (TT) mappings

-- ToggleTerm: Creates a new horizontal terminal
map("n", "<leader>h", function()
  require("toggleterm.terminal").Terminal:new({ direction = "horizontal" }):toggle()
end, vim.tbl_extend("force", opts, { desc = "TT: new horizontal terminal" }))
-- In normal mode, press 'Space' + 'h' to open a new horizontal terminal

-- ToggleTerm: Creates a new vertical terminal
map("n", "<leader>v", function()
  require("toggleterm.terminal").Terminal:new({ direction = "vertical" }):toggle()
end, vim.tbl_extend("force", opts, { desc = "TT: new vertical terminal" }))
-- In normal mode, press 'Space' + 'v' to open a new vertical terminal

-- ToggleTerm: Toggles the vertical terminal
map({ "n", "t" }, "<A-v>", function()
  require("toggleterm.terminal").Terminal:new({ direction = "vertical", id = "vtoggleTerm" }):toggle()
end, vim.tbl_extend("force", opts, { desc = "TT: toggle vertical terminal" }))
-- In normal or terminal mode, press 'Alt' + 'v' to toggle a vertical terminal on and off

-- ToggleTerm: Toggles a horizontal terminal
map({ "n", "t" }, "<A-h>", function()
  require("toggleterm.terminal").Terminal:new({ direction = "horizontal", id = "htoggleTerm" }):toggle()
end, vim.tbl_extend("force", opts, { desc = "TT: toggle horizontal terminal" }))
-- In normal or terminal mode, press 'Alt' + 'h' to toggle a horizontal terminal

-- ToggleTerm: Toggles a floating terminal
map({ "n", "t" }, "<A-i>", function()
  require("toggleterm.terminal").Terminal:new({ direction = "float", id = "floatTerm" }):toggle()
end, vim.tbl_extend("force", opts, { desc = "TT: toggle floating terminal" }))
-- In normal or terminal mode, press 'Alt' + 'i' to toggle a floating terminal

-- Zoxide mappings

-- Zoxide: Telescope lists your most visited directories for you to zoom into
map("n", "<leader>tz", "<cmd>Telescope zoxide list<CR>", vim.tbl_extend("force", opts, { desc = "TeleZoxide List" }))
-- In normal mode, press 'Space' + 't' + 'z' to open a list of directories with Zoxide

-- Zoxide: Interactively suggests directories to zoom into based on what you type without the list
map("n", "<leader>zi", "<cmd>Zi<CR>", vim.tbl_extend("force", opts, { desc = "Zoxide interactive" }))
-- In normal mode, press 'Space' + 'z' + 'i' to interactively navigate with Zoxide

-- Zoxide: Query lets you zoom directly into where you want to go when you know the name
map("n", "<leader>zq", ":Z ", vim.tbl_extend("force", opts, { desc = "Zoxide query" }))
-- In normal mode, press 'Space' + 'z' + 'q' followed by a directory name to query Zoxide

