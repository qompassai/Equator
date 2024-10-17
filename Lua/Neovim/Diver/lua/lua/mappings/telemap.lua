local map = vim.keymap.set

-- Telescope mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Teleind files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Telefive grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help" })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
map("n", "<leader>tma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>tfo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>tfc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>tgc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gts", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>tph", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>tff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>tfa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

local toggleterm = require("toggleterm.terminal").Terminal

-- Create new horizontal terminal
map("n", "<leader>h", function()
  toggleterm:new({ direction = "horizontal" }):toggle()
end, { desc = "New horizontal terminal" })

-- Create new vertical terminal
map("n", "<leader>v", function()
  toggleterm:new({ direction = "vertical" }):toggle()
end, { desc = "New vertical terminal" })

-- Toggle a vertical terminal
map({ "n", "t" }, "<A-v>", function()
  toggleterm:new({ direction = "vertical", id = "vtoggleTerm" }):toggle()
end, { desc = "Toggle vertical terminal" })

-- Toggle a horizontal terminal
map({ "n", "t" }, "<A-h>", function()
  toggleterm:new({ direction = "horizontal", id = "htoggleTerm" }):toggle()
end, { desc = "Toggle horizontal terminal" })

-- Toggle a floating terminal
map({ "n", "t" }, "<A-i>", function()
  toggleterm:new({ direction = "float", id = "floatTerm" }):toggle()
end, { desc = "Toggle floating terminal" })

-- Zoxide mappings
map("n", "<leader>z", "<cmd>Telescope zoxide list<CR>", { desc = "Zoxide (Telescope)" })
map("n", "<leader>zI", "<cmd>Zi<CR>", { desc = "Zoxide interactive" })
map("n", "<leader>zq", ":Z ", { desc = "Zoxide query" })
