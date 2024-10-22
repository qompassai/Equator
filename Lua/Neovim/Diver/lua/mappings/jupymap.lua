function M.capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    if cmp_nvim_lsp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end
    return capabilities
end

function M.on_attach(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    local map = vim.keymap.set

    -- Go to declaration
    map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "Go to declaration" }))
    -- In normal mode, press 'g' + 'D' to navigate to the declaration of the symbol under the cursor.

    -- Go to definition
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "Go to definition" }))
    -- In normal mode, press 'g' + 'd' to navigate to the definition of the symbol under the cursor.

    -- Go to implementation
    map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "Go to implementation" }))
    -- In normal mode, press 'g' + 'i' to navigate to the implementation of the symbol under the cursor.

    -- Show signature help
    map("n", "<leader>sh", vim.lsp.buf.signature_help, vim.tbl_extend("force", bufopts, { desc = "Show signature help" }))
    -- In normal mode, press 'Space' + 's' + 'h' to show signature information for the function under the cursor.

    -- Add workspace folder
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", bufopts, { desc = "Add workspace folder" }))
    -- In normal mode, press 'Space' + 'w' + 'a' to add the current folder as a workspace.

    -- Remove workspace folder
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", bufopts, { desc = "Remove workspace folder" }))
    -- In normal mode, press 'Space' + 'w' + 'r' to remove the current folder from the workspace.

    -- List workspace folders
    map("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend("force", bufopts, { desc = "List workspace folders" }))
    -- In normal mode, press 'Space' + 'w' + 'l' to list all folders currently in the workspace.

    -- Go to type definition
    map("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", bufopts, { desc = "Go to type definition" }))
    -- In normal mode, press 'Space' + 'D' to navigate to the type definition of the symbol under the cursor.

    -- Rename symbol
    map("n", "<leader>ra", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename symbol" }))
    -- In normal mode, press 'Space' + 'r' + 'a' to rename the symbol under the cursor.

    -- Code action
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "Code action" }))
    -- In normal and visual modes, press 'Space' + 'c' + 'a' to see available code actions at the current cursor position or selection.

    -- Show references
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "Show references" }))
    -- In normal mode, press 'g' + 'r' to list all references to the symbol under the cursor.

    -- Toggle Jupyter Lab terminal using toggleterm
    map("n", "<leader>jl", function()
        require("toggleterm.terminal").Terminal:new({ cmd = "jupyter lab", direction = "float" }):toggle()
    end, vim.tbl_extend("force", bufopts, { desc = "Toggle Jupyter Lab terminal" }))
    -- In normal mode, press 'Space' + 'j' + 'l' to open or close a floating Jupyter Lab terminal
end

return M

