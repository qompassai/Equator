local M = {}

M.telescope = {
  n = {
    ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find files" },
    ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
    ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", "Find buffers" },
    ["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
  },
}

return M
