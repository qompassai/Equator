-- ~/.config/nvim/lua/configs/theme_toggler.lua

-- Define the list of themes
local themes = {
    "catppuccin",
    "tokyonight",
    "onedark",
    "gruvbox-material",
    "nightfox",
}

-- Function to toggle through themes
local current_theme_index = 1
local function toggle_theme()
    current_theme_index = current_theme_index % #themes + 1
    local theme = themes[current_theme_index]

    -- Attempt to load the theme
    local ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
    if ok then
        vim.notify("Theme changed to: " .. theme, vim.log.levels.INFO)
    else
        vim.notify("Failed to load theme: " .. theme, vim.log.levels.ERROR)
    end
end

-- Function to set a specific theme
local function set_theme(theme)
    local ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
    if ok then
        vim.notify("Theme set to: " .. theme, vim.log.levels.INFO)
    else
        vim.notify("Failed to load theme: " .. theme, vim.log.levels.ERROR)
    end
end

-- Expose functions for use with key mappings or plugins
return {
    toggle_theme = toggle_theme,
    set_theme = set_theme,
    themes = themes,
}

-- ~/.config/nvim/lua/mappings/themes.lua

local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
  vim.notify("Failed to load which-key", vim.log.levels.ERROR)
  return
end

-- Register theme toggle key mapping with the new format
wk.register({
  { "<leader>t", name = "Themes" },
  { "<leader>tt", function() require("configs.theme_toggler").toggle_theme() end, "Toggle Theme" },
})
