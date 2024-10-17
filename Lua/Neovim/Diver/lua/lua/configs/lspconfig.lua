local M = {}

-- Function for default settings
function M.defaults()
    local lspconfig = require("lspconfig")
    local on_attach = M.on_attach
    local capabilities = M.capabilities()

    -- LSP servers you want to set up.
    local servers = {
        "pyright",
        "solargraph",
        "ts_ls",
        "gopls",
        "jdtls",
        "clangd",
        "omnisharp",
        "dockerls",
        "jsonls",
        "yamlls",
        "matlab_ls",
        "r_language_server",
    }

    -- Loop through the servers and set them up.
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end

    -- Lua Language Server setup with `on_attach` and `capabilities`
    lspconfig.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }
end

-- Capabilities function
function M.capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    if cmp_nvim_lsp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)  -- Updated to use default_capabilities
    end
    return capabilities
end

-- Function to handle LSP keymaps when LSP attaches to a buffer
function M.on_attach(_, bufnr) -- Replace 'client' with '_'
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    local map = vim.keymap.set

    map("n", "gD", vim.lsp.buf.declaration, bufopts)
    map("n", "gd", vim.lsp.buf.definition, bufopts)
    map("n", "gi", vim.lsp.buf.implementation, bufopts)
    map("n", "<leader>sh", vim.lsp.buf.signature_help, bufopts)
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    map("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    map("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    map("n", "<leader>ra", vim.lsp.buf.rename, bufopts)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
    map("n", "gr", vim.lsp.buf.references, bufopts)
end

return M

