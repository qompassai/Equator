--local which_key = require("which-key")

-- Get all available themes/colorschemes in Neovim
--local function get_colorschemes()
-- local themes = {}
--  for _, theme in pairs(vim.fn.getcompletion('', 'color')) do
--    table.insert(themes, theme)
--  end
--  return themes
--end

-- Generate the mappings dynamically based on available colorschemes
--local function generate_theme_mappings()
--  local themes = get_colorschemes()
--  local theme_mappings = {}

--  for _, theme in ipairs(themes) do
--    theme_mappings[theme] = { "<cmd>colorscheme " .. theme .. "<cr>", theme }
--  end

  -- Add Telescope picker for theme selection
--  theme_mappings["n"] = { "<cmd>lua require('telescope.builtin').colorscheme{}<cr>", "Choose Theme" }

-- return theme_mappings
--end

--local theme_mappings = generate_theme_mappings()

-- Integrate theme mappings with <leader>t
--local mappings = {
--  t = {
--    name = "Themes",
--    n = theme_mappings["n"],
--  },
-- }

-- Add individual theme mappings under <leader>t
-- for theme, command in pairs(theme_mappings) do
--  if theme ~= "n" then
    mappings.t[theme] = command
  end
end

local opts = {
  prefix = "<leader>",
}

-- which_key.register(mappings, opts)

