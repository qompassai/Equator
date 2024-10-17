local M = {}

-- Helper function to safely load a module
local function safe_require(module)
    local ok, result = pcall(require, module)
    return ok and result or nil
end

-- Import each mapping module safely
M.buffmap = safe_require("mappings.buffmap")
M.ensure_installed = safe_require("mappings.ensure_installed")
M.format = safe_require("mappings.format")
M.genmap = safe_require("mappings.genmap")
M.jupymap = safe_require("mappings.jupymap")
M.langmap = safe_require("mappings.langmap")
M.lsp = safe_require("mappings.lsp")
M.navmap = safe_require("mappings.navmap")
M.rustmap = safe_require("mappings.rustmap")
M.settings = safe_require("mappings.settings")
M.source = safe_require("mappings.source")
M.telemap = safe_require("mappings.telemap")
M.automatic_setup = safe_require("mappings.automatic_setup")

-- Example keybinding
vim.api.nvim_set_keymap('n', '<leader>th', '<cmd>Telescope colorscheme<CR>', { noremap = true, silent = true })

-- Return the module table to be used in other configurations
return M

