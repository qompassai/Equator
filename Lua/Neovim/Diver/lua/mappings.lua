local map = vim.keymap.set

-- general mapping
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "switch left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "file save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format files" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

-- buffer navigation
map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "buffer goto next" })
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "buffer goto prev" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "buffer close" })  -- Use regular buffer close

-- barbar
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:


-- blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })


--Rustacean mappings
local bufopts = { noremap = true, silent = true, buffer = true }
map("n", "gD", vim.lsp.buf.declaration, bufopts)
map("n", "gd", vim.lsp.buf.definition, bufopts)
map("n", "K", vim.lsp.buf.hover, bufopts)
map("n", "gi", vim.lsp.buf.implementation, bufopts)
map("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
map("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
map("n", "<space>rn", vim.lsp.buf.rename, bufopts)
map("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
map("n", "gr", vim.lsp.buf.references, bufopts)
map("n", "<space>f", function()
  vim.lsp.buf.format { async = true }
end, bufopts)
map("n", "<leader>rr", "<cmd>RustRunnables<CR>", { desc = "Rust Runnables" })
map("n", "<leader>rd", "<cmd>RustDebuggables<CR>", { desc = "Rust Debuggables" })
map("n", "<leader>rt", "<cmd>RustExpandMacro<CR>", { desc = "Rust Expand Macro" })
map("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", { desc = "Rust Open Cargo" })
map("n", "<leader>rp", "<cmd>RustParentModule<CR>", { desc = "Rust Parent Module" })
map("n", "gd", vim.lsp.buf.declaration, bufopts)
map("n", "gd", vim.lsp.buf.definition, bufopts)
map("n", "H", vim.lsp.buf.hover, bufopts)
map("n", "gi", vim.lsp.buf.implementation, bufopts)
map("n", "<c-k>", vim.lsp.buf.signature_help, bufopts)
map("n", "<space>d", vim.lsp.buf.type_definition, bufopts)
map("n", "<space>rn", vim.lsp.buf.rename, bufopts)
map("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
map("n", "gr", vim.lsp.buf.references, bufopts)
map("n", "<space>f", function()
  vim.lsp.buf.format { async = true }
end, bufopts)
map("n", "<leader>tc", function()
  local current = vim.opt.formatoptions:get()
  if vim.tbl_contains(current, "c") then
    vim.opt.formatoptions:remove "c"
    vim.opt.formatoptions:remove "r"
    vim.opt.formatoptions:remove "o"
    print "Comment continuation disabled"
  else
    vim.opt.formatoptions:append "c"
    vim.opt.formatoptions:append "r"
    vim.opt.formatoptions:append "o"
    print "Comment continuation enabled"
  end
end, { desc = "Toggle comment continuation" })



return M
