-- navmap.lua - Navigation key mappings configuration for Neovim

local navmap = {}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-------------- | Oil Mappings |---------------------

-- Open Oil File Explorer
map('n', '<leader>o', ':Oil<CR>', opts)
-- Press <Space> + o to open Oil file explorer

-- Move Up a Directory in Oil
map('n', '<leader>u', ':Oil -<CR>', opts)
-- Press <Space> + u to move up a directory in Oil

-- Open Oil in Home Directory
map('n', '<leader>oh', ':Oil ~/ <CR>', opts)
-- Press <Space> + o + h to open Oil in the home directory

-- Preview a File in Oil
map('n', '<leader>p', ':Oil preview<CR>', opts)
-- Press <Space> + p to preview a file with Oil

-- Close Oil Buffer
map('n', '<leader>oc', ':Oil close<CR>', opts)
-- Press <Space> + o + c to close the Oil buffer

-------------- | Treesitter Mappings | ---------------------

-- Incremental Selection
map('n', '<leader>si', ':TSNodeIncremental<CR>', opts)
-- Press <Space> + s + i to expand selection step by step

-- Decremental Selection
map('n', '<leader>sd', ':TSNodeDecremental<CR>', opts)
-- Press <Space> + s + d to shrink selection step by step

-- Scope Incremental Selection
map('n', '<leader>ss', ':TSScopeIncremental<CR>', opts)
-- Press <Space> + s + s to expand selection to the next larger code block

-- Select Entire Function
map('o', 'af', '<cmd>lua require"nvim-treesitter.textobjects.select".select_textobject("@function.outer")<CR>', opts)
-- Press 'a' + 'f' to select the entire function (including definition and body)

-- Select Function Body Only
map('o', 'if', '<cmd>lua require"nvim-treesitter.textobjects.select".select_textobject("@function.inner")<CR>', opts)
-- Press 'i' + 'f' to select only the body of the function

-- Select Entire Class
map('o', 'ac', '<cmd>lua require"nvim-treesitter.textobjects.select".select_textobject("@class.outer")<CR>', opts)
-- Press 'a' + 'c' to select the entire class (including definition and body)

-- Select Class Body Only
map('o', 'ic', '<cmd>lua require"nvim-treesitter.textobjects.select".select_textobject("@class.inner")<CR>', opts)
-- Press 'i' + 'c' to select only the body of the class

-- Navigate to Next Function Start
map('n', '<leader>nf', ':TSGotoNextFunction<CR>', opts)
-- Press <Space> + n + f to go to the start of the next function

-- Navigate to Previous Function Start
map('n', '<leader>pf', ':TSGotoPreviousFunction<CR>', opts)
-- Press <Space> + p + f to go to the start of the previous function

-- Toggle Highlighting
map('n', '<leader>th', ':TSToggleHighlight<CR>', opts)
-- Press <Space> + t + h to turn syntax highlighting on or off

-- Toggle Treesitter Playground
map('n', '<leader>tp', ':TSTogglePlayground<CR>', opts)
-- Press <Space> + t + p to open or close the Treesitter Playground

-- Show Treesitter Captures Under Cursor
map('n', '<leader>tq', ':TSShowCaptures<CR>', opts)
-- Press <Space> + t + q to show syntax info under the cursor

-- Swap Current Parameter with Next
map('n', '<leader>sn', ':TSSwapNextParameter<CR>', opts)
-- Press <Space> + s + n to swap the current parameter with the next one

-- Swap Current Parameter with Previous
map('n', '<leader>sp', ':TSSwapPreviousParameter<CR>', opts)
-- Press <Space> + s + p to swap the current parameter with the previous one

-- Toggle Folding
map('n', '<leader>cf', ':TSToggleFold<CR>', opts)
-- Press <Space> + c + f to fold or unfold code blocks

return navmap
