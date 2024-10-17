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

