local map = vim.keymap.set

-- Ensure automatic_setup is properly required
local automatic_setup = require("mappings.automatic_setup")

-- Ensure that the formatter is registered if it isn't already
if type(automatic_setup) == "function" then
    automatic_setup("stylua", { "formatting" })
else
    vim.notify("Error: automatic_setup is not a function", vim.log.levels.ERROR)
end

-- Format mapping for Lua files
map("n", "<leader>mf", function()
    local status, conform = pcall(require, "conform")
    if not status then
        vim.notify("Error loading conform: " .. conform, vim.log.levels.ERROR)
        return
    end
    conform.format { lsp_fallback = true }
end, { desc = "Format files" })

return {}

