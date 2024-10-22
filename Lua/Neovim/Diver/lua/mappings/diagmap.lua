local map = vim.keymap.set

-- Trouble diagnostics toggle
map("n", "<leader>Td", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble toggle Diag Window" })
-- In normal mode, press 'Space' + 'T' + 'd' to toggle the Trouble diagnostics window

-- Toggle Trouble diagnostics for the current buffer only
map("n", "<leader>Tb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble toggle in-file" })
-- In normal mode, press 'Space' + 'T' + 'b' to toggle Trouble diagnostics for the current buffer

-- Toggle Trouble symbols window without focusing
map("n", "<leader>Ts", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble toggle symbols" })
-- In normal mode, press 'Space' + 'T' + 'b' to toggle the Trouble symbols window without changing focus

-- Toggle Trouble LSP window on the right side without focusing
map("n", "<leader>Tw", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "Trouble toggle LSP window" })
-- In normal mode, press 'Space' + 'T' + 'w' to toggle the Trouble LSP window on the right side without changing focus

-- Toggle Trouble location list
map("n", "<leader>Tl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
-- In normal mode, press 'Space' + 'T' + 'l' to toggle the Trouble location list

-- Toggle Trouble quickfix list
map("n", "<leader>Tq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
-- In normal mode, press 'Space' + 'T' + 'q' to toggle the Trouble quickfix list


-- Start debugging session
map('n', '<leader>ds', "<cmd>lua require'dap'.continue()<CR>", { desc = 'Start debugging session' })
-- In normal mode, press 'Space' + 'd' + 's' to start a debugging session

-- Toggle breakpoint
map('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = 'Toggle breakpoint' })
-- In normal mode, press 'Space' + 'd' + 'b' to toggle a breakpoint

-- Step over
map('n', '<leader>dn', "<cmd>lua require'dap'.step_over()<CR>", { desc = 'Step over' })
-- In normal mode, press 'Space' + 'd' + 'n' to step over

-- Step into
map('n', '<leader>di', "<cmd>lua require'dap'.step_into()<CR>", { desc = 'Step into' })
-- In normal mode, press 'Space' + 'd' + 'i' to step into

-- Step out
map('n', '<leader>do', "<cmd>lua require'dap'.step_out()<CR>", { desc = 'Step out' })
-- In normal mode, press 'Space' + 'd' + 'o' to step out

-- Toggle DAP REPL
map('n', '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = 'Toggle DAP REPL' })
-- In normal mode, press 'Space' + 'd' + 'r' to toggle the DAP REPL

-- Show DAP UI
map('n', '<leader>du', "<cmd>lua require'dapui'.toggle()<CR>", { desc = 'Toggle DAP UI' })
-- In normal mode, press 'Space' + 'd' + 'u' to toggle the DAP UI
