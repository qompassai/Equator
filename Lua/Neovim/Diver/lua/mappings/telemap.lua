local map = vim.keymap.set

-- Nerd Translate Legend:
--
-- 'Alt': The alternate key on your keyboard, usually next to the space bar.
-- 'Buffer': A temporary place to keep an open file. In neovim buffer=file more or less.
-- 'Ctrl': The control key, usually at the bottom of the keyboard.
-- 'Directory': A digital storage place for your files, aka "folder".
-- 'File': A document or piece of information saved on your computer, like a drawing that you store in a drawer.
-- Fuzzy Finding: Search for things your memory's a little "fuzzy" on.
-- 'Grep': A tool to quickly find words or phrases in files. It's like looking through your documents with a magnifying glass to find specific words.
-- 'Leader/Leader key': The 'Space' key, which you press in normal mode before other keys to run commands.
-- 'Mappings': Custom keyboard shortcuts unique to each Diver tool. TLDR: Type less, do more.
-- 'Mark': A virtual bookmark in your text that lets you quickly jump back to important spots in your code or document.
-- 'NvimTree': A file explorer to see all the folders and files in a "tree"-like structure. Think file explorer in Windows.
-- 'Telescope': A free & open-source tool to search and find your data on your computer.
-- 'ToggleTerm': A way to open new windows in your terminal.
-- 'Zoxide': A tool to quickly jump to the places you visit most often.

-- Telescope mappings

-- Telescope finds files on your computer
map("n", "<leader>tff", "<cmd>Telescope find_files<CR>", { desc = "Telefind files" })
-- In normal mode, press 'Space' + 't' + 'f' + 'f' to open Telescope and search for files

-- Telescope live searches your computer by the word.
map("n", "<leader>tls", "<cmd>Telescope live_grep<CR>", { desc = "Telelive search" })
-- In normal mode, press 'Space' + 'f' + 'g' to search for text across files

-- Telescope finds all the open files that you're working on
map("n", "<leader>tfb", "<cmd>Telescope buffers<CR>", { desc = "Telefind buffers" })
-- In normal mode, press 'Space' + 't' + 'f' + 'b' to open a list of open buffers

-- Find help tags using Telescope
map("n", "<leader>tfh", "<cmd>Telescope help_tags<CR>", { desc = "Telefind help" })
-- In normal mode, press 'Space' + 't' + 'f' + 'h' to search through help documentation

-- NvimTree: Lets you navigate like you would a tree- climbing up and down by "branch".

-- Toggle NvimTree file explorer window (open or close the file manager window)
map("n", "<leader>nt", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
-- In normal mode, press 'Space' + 'n' + 't' to open or close the NvimTree window

-- Focus the NvimTree file explorer window
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })
-- In normal mode, press 'Space' + 'e' to focus on the NvimTree window

-- Telescope Find marks
map("n", "<leader>tma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
-- In normal mode, press 'Space' + 't' + 'm' + 'a' to list marks

-- Telescope find old files
map("n", "<leader>tfo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
-- In normal mode, press 'Space' + 't' + 'f' + 'o' to list recently opened files

-- Telescope fuzzy search current file
map("n", "<leader>tfc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
-- In normal mode, press 'Space' + 't' + 'f' + 'c' to search for text in the current buffer

-- Find git commits using Telescope
map("n", "<leader>tgc", "<cmd>Telescope git_commits<CR>", { desc = "Telefind git commits" })
-- In normal mode, press 'Space' + 't' + 'g' + 'c' to list git commits

-- Check git status using Telescope
map("n", "<leader>tgs", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
-- In normal mode, press 'Space' + 'g' + 't' + 's' to check git status

-- Pick hidden terminal using Telescope
map("n", "<leader>tr", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
-- In normal mode, press 'Space' + 't' + 'p' + 'h' to list hidden terminals

-- Telescope finds all hidden & ignored files
map("n", "<leader>tfa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "telescope find all files" })
-- In normal mode, press 'Space' + 't' + 'f' + 'a' to search for all files, even hidden ones

-- ToggleTerm mappings

local toggleterm = require("toggleterm.terminal").Terminal

-- Toggleterm creates a new horizontal terminal.
map("n", "<leader>h", function()
  toggleterm:new({ direction = "horizontal" }):toggle()
end, { desc = "New horizontal terminal" })
-- In normal mode, press 'Space' + 'h' to open a new horizontal terminal

-- Toggleterm creates a new vertical terminal
map("n", "<leader>v", function()
  toggleterm:new({ direction = "vertical" }):toggle()
end, { desc = "New vertical terminal" })
-- In normal mode, press 'Space' + 'v' to open a new vertical terminal

-- Toggleterm "toggles" the vertical terminal
map({ "n", "t" }, "<A-v>", function()
  toggleterm:new({ direction = "vertical", id = "vtoggleTerm" }):toggle()
end, { desc = "Toggle vertical terminal" })
-- In normal or terminal mode, press 'Alt' + 'v' to toggle a vertical terminal on and off.

-- Toggleterm "toggles" a horizontal terminal
map({ "n", "t" }, "<A-h>", function()
  toggleterm:new({ direction = "horizontal", id = "htoggleTerm" }):toggle()
end, { desc = "Toggle horizontal terminal" })
-- In normal or terminal mode, press 'Alt' + 'h' to toggle a horizontal terminal

-- Toggle a floating terminal
map({ "n", "t" }, "<A-i>", function()
  toggleterm:new({ direction = "float", id = "floatTerm" }):toggle()
end, { desc = "Toggle floating terminal" })
-- In normal or terminal mode, press 'Alt' + 'i' to toggle a floating terminal

-- Zoxide mappings

-- Telescope Zoxides a list of your most visited directories for you to zoom into.
map("n", "<leader>tz", "<cmd>Telescope zoxide list<CR>", { desc = "TeleZoxide List" })
-- In normal mode, press 'Space' + 't' + 'z' to open a list of directories with Zoxide

-- Zoxide interactively suggests directories to zoom into based on what you type without the list.
map("n", "<leader>zi", "<cmd>Zi<CR>", { desc = "Zoxide interactive" })
-- In normal mode, press 'Space' + 'z' + 'i' to interactively navigate with Zoxide

-- Zoxide query lets you zoom directly into where you want to go when you know the name.
map("n", "<leader>zq", ":Z ", { desc = "Zoxide query" })
-- In normal mode, press 'Space' + 'z' + 'q' followed by a directory name to query Zoxide
