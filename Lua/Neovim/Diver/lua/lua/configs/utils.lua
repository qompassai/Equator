
local M = {}

-- Define a path_join function
function M.path_join(...)
    local args = {...}
    return table.concat(args, "/")
end

-- Optionally add more utility functions here...

return M

