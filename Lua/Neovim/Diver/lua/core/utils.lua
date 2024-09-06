local M = {}

M.load_mappings = function(section)
  local function set_section_map(section_values)
    for mode, mode_values in pairs(section_values) do
      for keybind, mapping_info in pairs(mode_values) do
        local opts = mapping_info.opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, keybind, mapping_info[1], opts)
      end
    end
  end

  local mappings = require("core.mappings")
  if type(section) == "string" then
    mappings[section]["plugin"] = nil
    set_section_map(mappings[section])
  elseif type(section) == "table" then
    for _, sec in ipairs(section) do
      set_section_map(mappings[sec])
    end
  end
end

return M
