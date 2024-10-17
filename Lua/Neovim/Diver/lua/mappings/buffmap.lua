local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Buffer navigation
map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "buffer goto next" })
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "buffer goto prev" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "buffer close" })


return {}

