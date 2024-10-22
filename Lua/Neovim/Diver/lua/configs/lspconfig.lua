local M = {}

function M.defaults()
  local lspconfig = require "lspconfig"
  local on_attach = M.on_attach
  local capabilities = M.capabilities()

  local servers = {
    "pyright",
    "solargraph",
    "ts_ls",
    "gopls",
    "jdtls",
    "clangd",
    "dockerls",
    "jsonls",
    "yamlls",
    "matlab_ls",
    "r_language_server",
    "zls",
  }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end

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
  lspconfig.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "zig" },
    root_dir = lspconfig.util.root_pattern("zls.json", ".git"),
  }
end

function M.capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_nvim_lsp = require "cmp_nvim_lsp"
  if cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

function M.on_attach(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local map = vim.keymap.set

  -- Nvim-LSP Go to declaration
  map(
    "n",
    "lD",
    vim.lsp.buf.declaration,
    vim.tbl_extend("force", bufopts, { desc = "Nvim-[l]SP go to symbol [D]eclaration under cursor" })
  )
  -- In normal mode, press 'l' + 'D' to navigate to the declaration of the symbol under the cursor.

  -- Nvim-LSP Go to definition
  map(
    "n",
    "ls",
    vim.lsp.buf.definition,
    vim.tbl_extend("force", bufopts, { desc = "Nvim-[l]SP go to [s]ymbol definition under cursor" })
  )
  -- In normal mode, press 'l' + 's' to navigate to the definition of the symbol under the cursor.

  -- Go to implementation
  map(
    "n",
    "li",
    vim.lsp.buf.implementation,
    vim.tbl_extend("force", bufopts, { desc = "Nvim-LSP [g]o to [i]mplementation under cursor" })
  )
  -- In normal mode, press 'l' + 'i' to navigate to the implementation of the symbol under the cursor.

  -- Show signature help
  map(
    "n",
    "<leader>sh",
    vim.lsp.buf.signature_help,
    vim.tbl_extend("force", bufopts, { desc = "Nvim-LSP [s]how signature [h]elp" })
  )
  -- In normal mode, press 'Space' + 's' + 'h' to show signature information for the function under the cursor.

  -- Add workspace folder
  map(
    "n",
    "<leader>wa",
    vim.lsp.buf.add_workspace_folder,
    vim.tbl_extend("force", bufopts, { desc = "Nvim-LSP [w]orkspace [a]dd folder" })
  )
  -- In normal mode, press 'Space' + 'w' + 'a' to add the current folder as a workspace.

  -- Remove workspace folder
  map(
    "n",
    "<leader>wf",
    vim.lsp.buf.remove_workspace_folder,
    vim.tbl_extend("force", bufopts, { desc = "Nvim-LSP remove [w]orkspace [f]older" })
  )
  -- In normal mode, press 'Space' + 'w' + 'f' to remove the current folder from the workspace.

  -- List workspace folders
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, vim.tbl_extend("force", bufopts, { desc = "Nvim-LSP [l]ist [w]orkspace folders" }))
  -- In normal mode, press 'Space' + 'w' + 'l' to list all folders currently in the workspace.

  -- Go to type definition
  map(
    "n",
    "<leader>ld",
    vim.lsp.buf.type_definition,
    vim.tbl_extend("force", bufopts, { desc = "Nvim-[l]SP go to type [D]efinition under cursor" })
  )
  -- In normal mode, press 'Space' + 'l' + 'd' to navigate to the type definition of the symbol under the cursor.

  -- Nvim-LSP Rename symbol
  map("n", "<leader>rs", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Nvim-LSP [r]ename [s]ymbol" }))
  -- In normal mode, press 'Space' + 'r' + 'a' to rename the symbol under the cursor.

  -- Nvim-LSP Code action
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "LSP Code action" }))
  -- In normal and visual modes, press 'Space' + 'c' + 'a' to see available code actions at the current cursor position or selection.

  -- Show references
  map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "LSP Show references" }))
  -- In normal mode, press 'g' + 'r' to list all references to the symbol under the cursor.
end

return M
