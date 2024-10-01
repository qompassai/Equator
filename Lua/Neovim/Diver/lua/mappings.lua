local map = vim.keymap.set

-- general mapping
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "file save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format files" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>new<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

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
--  :BarbarEnable - enables barbar (enabled by default)
-- Comment
map("n", "<leader>/", "gcc", { desc = "comment toggle", remap = true })
map("v", "<leader>/", "gc", { desc = "comment toggle", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal new horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

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

-- Zoxide mappings
map("n", "<leader>z", "<cmd>Telescope zoxide list<CR>", { desc = "Zoxide (Telescope)" })
map("n", "<leader>zI", "<cmd>Zi<CR>", { desc = "Zoxide interactive" })
map("n", "<leader>zq", ":Z ", { desc = "Zoxide query" })

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

--null-ls
local null_ls = require "null-ls"

map("n", "<leader>tn", function()
  if null_ls.is_registered "diagnostics" then
    null_ls.disable "diagnostics"
    print "null-ls diagnostics disabled"
  else
    null_ls.enable "diagnostics"
    print "null-ls diagnostics enabled"
  end
end, { desc = "Toggle null-ls diagnostics" })

-- mason-null-ls
local _ = require('mason-core.functional')
local Optional = require('mason-core.optional')



---Maps null_ls source name to its corresponding package name.

local null_ls_to_package = {
	['cmake_lint'] = 'cmakelint',
	['cmake_format'] = 'cmakelang',
	['eslint_d'] = 'eslint_d',
	['goimports_reviser'] = 'goimports_reviser',
	['phpcsfixer'] = 'php-cs-fixer',
	['verible_verilog_format'] = 'verible',
	['lua_format'] = 'luaformatter',
	['ansiblelint'] = 'ansible-lint',
	['deno_fmt'] = 'deno',
	['ruff_format'] = 'ruff',
	['xmlformat'] = 'xmlformatter',
}

local package_to_null_ls = _.invert(null_ls_to_package)
local M = {}
---@param source string: Source Name from NullLs
---@return string: Package Name from Mason
M.getPackageFromNullLs = _.memoize(function(source)
	return Optional.of_nilable(null_ls_to_package[source]):or_else_get(_.always(source:gsub('%_', '-')))
end)

---@param package string: Package Name from Mason
---@return string: NullLs Source Name
M.getNullLsFromPackage = _.memoize(function(package)
	return Optional.of_nilable(package_to_null_ls[package]):or_else_get(_.always(package:gsub('%-', '_')))
end)

--lsp diag
map("n", "<leader>tl", function()
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    vim.diagnostic.enable(false)
    for _, client in ipairs(clients) do
      client.stop()
    end
    print "LSP diagnostics disabled"
  else
    vim.diagnostic.enable()
    vim.cmd "LspStart"
    print "LSP diagnostics enabled"
  end
end, { desc = "Toggle LSP diagnostics" })

-- Jupyter Notebook Mappings
map("n", "<leader>jc", "<cmd>JupyterConnect<CR>", { desc = "Connect to Jupyter kernel" })
map("n", "<leader>jr", "<cmd>JupyterRunCell<CR>", { desc = "Run current Jupyter cell" })
map("n", "<leader>ja", "<cmd>JupyterRunAll<CR>", { desc = "Run all Jupyter cells" })
map("n", "<leader>jn", "<cmd>JupyterNewCell<CR>", { desc = "Create new cell below" })
map("n", "<leader>jb", "<cmd>JupyterNewCellAbove<CR>", { desc = "Create new cell above" })
map("n", "<leader>jd", "<cmd>JupyterDeleteCell<CR>", { desc = "Delete current cell" })
map("n", "<leader>js", "<cmd>JupyterSplitCell<CR>", { desc = "Split current cell" })
map("n", "<leader>jm", "<cmd>JupyterMergeCellBelow<CR>", { desc = "Merge cell with cell below" })
map("n", "<leader>jt", "<cmd>JupyterToggleCellType<CR>", { desc = "Toggle cell type (code/markdown)" })
map("n", "<leader>jp", "<cmd>JupyterTogglePythonRepl<CR>", { desc = "Toggle Python REPL" })
map("n", "<leader>jv", "<cmd>JupyterViewOutput<CR>", { desc = "View output of last executed cell" })
map("n", "<leader>jh", "<cmd>JupyterCommandHistory<CR>", { desc = "Show Jupyter command history" })
map("n", "<leader>ji", "<cmd>JupyterInsertImports<CR>", { desc = "Insert cell with common Python imports" })
map("n", "<leader>jf", "<cmd>JupyterFormatNotebook<CR>", { desc = "Format entire notebook" })

-- Jupyter Notebook Mappings
map("n", "<leader>jx", ":Jupytext<CR>", { desc = "Convert between notebook and script" })

-- Jupyter connection and file operations
map("n", "<leader>jc", ":JupyterConnect<CR>", { desc = "Connect to Jupyter kernel" })
map("n", "<leader>jr", ":JupyterRunFile<CR>", { desc = "Run current file in Jupyter" })
map("n", "<leader>ji", ":PythonImportThisFile<CR>", { desc = "Import current file in Jupyter" })
map("n", "<leader>jd", ":JupyterCd %:p:h<CR>", { desc = "Change Jupyter working directory to current file" })

-- Cell operations
map("n", "<leader>jn", ":JupyterNewCell<CR>", { desc = "Create new cell below" })
map("n", "<leader>jb", ":JupyterNewCellAbove<CR>", { desc = "Create new cell above" })
map("n", "<leader>jD", ":JupyterDeleteCell<CR>", { desc = "Delete current cell" })
map("n", "<leader>js", ":JupyterSplitCell<CR>", { desc = "Split current cell" })
map("n", "<leader>jm", ":JupyterMergeCellBelow<CR>", { desc = "Merge cell with cell below" })
map("n", "<leader>jt", ":JupyterToggleCellType<CR>", { desc = "Toggle cell type (code/markdown)" })

-- Cell execution
map("n", "<leader>je", ":JupyterSendCell<CR>", { desc = "Execute current cell" })
map("n", "<leader>jE", ":JupyterCellExecuteCellJump<CR>", { desc = "Execute current cell and jump to next" })
map("n", "<leader>ja", ":JupyterRunAllCells<CR>", { desc = "Run all cells" })
map("n", "<leader>jA", ":JupyterRunAllCellsAbove<CR>", { desc = "Run all cells above" })
map("n", "<leader>jB", ":JupyterRunAllhellsBelow<CR>", { desc = "Run all cells below" })

-- Output and REPL
map("n", "<leader>jp", ":JupyterTogglePythonRepl<CR>", { desc = "Toggle Python REPL" })
map("n", "<leader>jv", ":JupyterViewOutput<CR>", { desc = "View output of last executed cell" })
map("n", "<leader>jh", ":JupyterCommandHistory<CR>", { desc = "Show Jupyter command history" })
map("n", "<leader>jC", ":JupyterCellClear<CR>", { desc = "Clear current cell output" })

-- Navigation
map("n", "[c", ":JupyterCellPrev<CR>", { desc = "Go to previous cell" })
map("n", "]c", ":JupyterCellNext<CR>", { desc = "Go to next cell" })

-- ToggleTerm for Jupyter Lab
map(
  "n",
  "<leader>jl",
  "<cmd>ToggleTerm direction=float<CR>jupyter lab<CR>",
  { desc = "Open Jupyter Lab in floating terminal" }
)

-- Additional operations
map("n", "<leader>jf", ":JupyterFormatNotebook<CR>", { desc = "Format entire notebook" })
map("n", "<leader>jU", ":JupyterUpdateShell<CR>", { desc = "Update Jupyter shell" })

-- Hover
--local hover = require("hover")
--map("n", "K", hover.hover, { desc = "hover.nvim" })
--map("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" })
--map("n", "<C-p>", function()
--    hover.hover_switch("previous")
--end, { desc = "hover.nvim (previous source)" })
--map("n", "<C-n>", function()
--    hover.hover_switch("next")
--end, { desc = "hover.nvim (next source)" })
return M
