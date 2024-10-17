local M = {}

M.setup = function()
  local map = vim.keymap.set

  -- Function to check if Jupyter is installed
  local function is_jupyter_available()
    local ok, _ = pcall(require, "jupyter")
    return ok
  end

  -- Setup Jupyter mappings if available
  if is_jupyter_available() then
-- Nerd Translate Legend:
-- 'Jupyter': An interactive computing environment populare in data science.
-- 'Kernel': The computational engine that executes code in a Jupyter notebook.
-- 'Cell': A container for code, text, or other content in a Jupyter notebook.
-- 'REPL': Read-Eval-Print Loop, an interactive programming environment that takes single user inputs.

    -- Jupyter Mappings: Control your Jupyter notebooks directly from Neovim

    -- Connect to Jupyter kernel
    map("n", "<leader>jc", "<cmd>JupyterConnect<CR>", { desc = "Jupyter connect to kernel" })
    -- In normal mode, press 'Space' + 'j' + 'c' to connect to a Jupyter kernel

    -- Run current Jupyter cell
    map("n", "<leader>jr", "<cmd>JupyterRunCell<CR>", { desc = "Jupyter run current cell" })
    -- In normal mode, press 'Space' + 'j' + 'r' to execute the current Jupyter cell

    -- Run all Jupyter cells
    map("n", "<leader>ja", "<cmd>JupyterRunAll<CR>", { desc = "Jupyter run all cells" })
    -- In normal mode, press 'Space' + 'j' + 'a' to run all cells in the notebook

    -- Create new Jupyter cell below
    map("n", "<leader>jn", "<cmd>JupyterNewCell<CR>", { desc = "Create new cell below" })
    -- In normal mode, press 'Space' + 'j' + 'n' to create a new cell below the current one

    -- Create new Jupyter cell above
    map("n", "<leader>jb", "<cmd>JupyterNewCellAbove<CR>", { desc = "Create new cell above" })
    -- In normal mode, press 'Space' + 'j' + 'b' to create a new cell above the current one

    -- Delete current Jupyter cell
    map("n", "<leader>jd", "<cmd>JupyterDeleteCell<CR>", { desc = "Delete current cell" })
    -- In normal mode, press 'Space' + 'j' + 'd' to delete the current cell

    -- Split current Jupyter cell
    map("n", "<leader>js", "<cmd>JupyterSplitCell<CR>", { desc = "Split current cell" })
    -- In normal mode, press 'Space' + 'j' + 's' to split the current cell into two

    -- Merge Jupyter cell with cell below
    map("n", "<leader>jm", "<cmd>JupyterMergeCellBelow<CR>", { desc = "Merge cell with cell below" })
    -- In normal mode, press 'Space' + 'j' + 'm' to merge the current cell with the one below it

    -- Toggle Jupyter cell type
    map("n", "<leader>jt", "<cmd>JupyterToggleCellType<CR>", { desc = "Toggle cell type (code/markdown)" })
    -- In normal mode, press 'Space' + 'j' + 't' to switch the cell type between code and markdown

    -- Toggle Python REPL
    map("n", "<leader>jp", "<cmd>JupyterTogglePythonRepl<CR>", { desc = "Toggle Python REPL" })
    -- In normal mode, press 'Space' + 'j' + 'p' to open or close the Python REPL

    -- View output of last executed Jupyter cell
    map("n", "<leader>jv", "<cmd>JupyterViewOutput<CR>", { desc = "View output of last executed cell" })
    -- In normal mode, press 'Space' + 'j' + 'v' to see the output of the most recently run cell

    -- Show Jupyter command history
    map("n", "<leader>jh", "<cmd>JupyterCommandHistory<CR>", { desc = "Show Jupyter command history" })
    -- In normal mode, press 'Space' + 'j' + 'h' to display a list of previously executed Jupyter commands

    -- Insert cell with common Python imports
    map("n", "<leader>ji", "<cmd>JupyterInsertImports<CR>", { desc = "Insert cell with common Python imports" })
    -- In normal mode, press 'Space' + 'j' + 'i' to create a new cell with frequently used Python import statements

    -- Format entire Jupyter notebook
    map("n", "<leader>jf", "<cmd>JupyterFormatNotebook<CR>", { desc = "Format entire notebook" })
    -- In normal mode, press 'Space' + 'j' + 'f' to apply formatting to the entire Jupyter notebook
    -- Toggle Jupyter Lab terminal
    map("n", "<leader>jl", function()
      require("toggleterm.terminal").Terminal
        :new({ cmd = "jupyter lab", direction = "float" })
        :toggle()
    end, { desc = "Toggle Jupyter Lab terminal" })
    -- In normal mode, press 'Space' + 'j' + 'l' to open or close a floating Jupyter Lab terminal
  end
end

return M

