local map = vim.keymap.set

-- Function to conditionally load Jupyter mappings
local function setup_jupyter_mappings()
  -- Check if the Jupyter plugin/module is available
  local jupyter_loaded, _ = pcall(require, "jupyter")

  if not jupyter_loaded then
    return -- Exit if the Jupyter plugin is not loaded
  end

  -- Jupyter Notebook Mappings (only if plugin is available)
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
  -- Additional Jupyter operations...
end

-- Execute the function to set up the mappings
setup_jupyter_mappings()

return {}

