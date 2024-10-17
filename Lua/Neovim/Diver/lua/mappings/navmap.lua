
local navmap = {}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Nerd Translate Legend:
--
-- 'Oil': A file manager that lets you interactively edit your directory/file systems
-- 'Treesitter': A parsing system that provides detailed information about the structure of source code
-- 'Directory': A folder on your computer that contains files and other folders
-- 'Buffer': A temporary space in memory where a file is loaded for editing
-- 'File Explorer': A tool that shows you the files and folders on your computer
-- 'Home Directory': The main folder for your user account on the computer
-- 'Preview': A quick look at a file without fully opening it
-- 'Selection': The part of text you've highlighted or chosen
-- 'Function': A block of code that performs a specific task, eg adding up prices of items in a shopping cart.
-- 'Class': A blueprint for creating objects in programming, eg a 'Car' class that defines properties like 'color' and 'model', and actions like 'start' and 'stop'.
-- 'Syntax Highlighting': Coloring different parts of code to make it easier to read
-- 'Playground': A place to experiment and see how Treesitter understands your code
-- 'Captures': How Treesitter identifies different parts of your code
-- 'Parameter': A value that you pass into a function
-- 'Code Folding': Hiding parts of your code to make it easier to read

-------------- | Oil Mappings |---------------------

-- Open Oil File Explorer
map('n', '<leader>of', ':Oil<CR>', { desc = "Oil Open File Explorer" })
-- In normal mode, press 'Space' + 'o' + 'f' to open Oil file explorer

-- Move Up a Directory in Oil
map('n', '<leader>ou', ':Oil -<CR>', { desc = "Oil Move Up a Directory" })
-- In normal mode, press 'Space' + 'u' to move up a directory in Oil

-- Open Oil in Home Directory
map('n', '<leader>oh', ':Oil ~/ <CR>', { desc = "Oil Open in Home Directory (~)" })
-- In normal mode, press 'Space' + 'o' + 'h' to open Oil in the home directory

-- Preview a File in Oil
map('n', '<leader>op', ':Oil preview<CR>', { desc = "Oil Preview File" })
-- In normal mode, press 'Space' + 'p' to preview a file with Oil

-- Close Oil Buffer
map('n', '<leader>oc', ':Oil close<CR>', { desc = "Close Oil buffer" })
-- In normal mode, press 'Space' + 'o' + 'c' to close the Oil buffer

-------------- | Treesitter Mappings | ---------------------

-- Treesitter Incremental Selection
map('n', '<leader>si', ':TSNodeIncremental<CR>', { desc = "Expand selection incrementally" })
-- In normal mode, press 'Space' + 's' + 'i' to expand selection step by step

-- Decremental Selection
map('n', '<leader>sd', ':TSNodeDecremental<CR>', { desc = "Shrink selection decrementally" })
-- In normal mode, press 'Space' + 's' + 'd' to shrink selection step by step

-- Scope Incremental Selection
map('n', '<leader>ss', ':TSScopeIncremental<CR>', { desc = "Expand selection to next larger code block" })
-- In normal mode, press 'Space' + 's' + 's' to expand selection to the next larger code block

-- Select Entire Function
map('o', 'af', '<cmd>lua require"nvim-treesitter.textobjects.select".select_textobject("@function.outer")<CR>', { desc = "Select entire function" })
-- In operator-pending mode, press 'a' + 'f' to select the entire function (including definition and body)

-- Select Function Body Only
map('o', 'if', '<cmd>lua require"nvim-treesitter.textobjects.select".select_textobject("@function.inner")<CR>', { desc = "Select function body" })
-- In operator-pending mode, press 'i' + 'f' to select only the body of the function

-- Select Entire Class
map('o', 'ac', '<cmd>lua require"nvim-treesitter.textobjects.select".select_textobject("@class.outer")<CR>', { desc = "Select entire class" })
-- In operator-pending mode, press 'a' + 'c' to select the entire class (including definition and body)

-- Select Class Body Only
map('o', 'ic', '<cmd>lua require"nvim-treesitter.textobjects.select".select_textobject("@class.inner")<CR>', { desc = "Select class body" })
-- In operator-pending mode, press 'i' + 'c' to select only the body of the class

-- Navigate to Next Function Start
map('n', '<leader>tn', ':TSGotoNextFunction<CR>', { desc = "TreeSitter -> next function" })
-- In normal mode, press 'Space' + 't' + 'n' to go to the start of the next function

-- Navigate to Previous Function Start
map('n', '<leader>tp', ':TSGotoPreviousFunction<CR>', { desc = "Treesitter <- previous function" })
-- In normal mode, press 'Space' + 't' + 'p' to go to the start of the previous function

-- Toggle Highlighting
map('n', '<leader>ts', ':TSToggleHighlight<CR>', { desc = "Treesitter toggle syntax highlight" })
-- In normal mode, press 'Space' + 't' + 's ' to turn syntax highlighting on or off

-- Toggle Treesitter Playground
map('n', '<leader>tP', ':TSTogglePlayground<CR>', { desc = "Treesitter toggle Playground" })
-- In normal mode, press 'Space' + 't' + 'P' to open or close the Treesitter Playground

-- Show Treesitter Captures Under Cursor
map('n', '<leader>tu', ':TSShowCaptures<CR>', { desc = "Treesitter show syntax info under cursor" })
-- In normal mode, press 'Space' + 't' + 'u' to show syntax info under the cursor

-- Treesitter Swap Current Parameter with Next
map('n', '<leader>sn', ':TSSwapNextParameter<CR>', { desc = "Treesitter Swap with next parameter" })
-- In normal mode, press 'Space' + 's' + 'n' to swap the current parameter with the next one

-- Swap Current Parameter with Previous
map('n', '<leader>sp', ':TSSwapPreviousParameter<CR>', { desc = "Treesitter Swap with previous parameter" })
-- In normal mode, press 'Space' + 's' + 'p' to swap the current parameter with the previous one

-- Treesitter Toggle Folding
map('n', '<leader>cf', ':TSToggleFold<CR>', { desc = "Toggle code folding" })
-- In normal mode, press 'Space' + 'c' + 'f' to fold or unfold code blocks

return navmap

