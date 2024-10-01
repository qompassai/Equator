local api = vim.api
local dap = require('dap')
local ui = require('dap.ui')
local widgets = require('dap.ui.widgets')
-- Safely require hover
local hover_ok, hover = pcall(require, 'hover')
if not hover_ok then
  print("hover module not found. Some functionality may be limited.")
  return
end

local function find_window (buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end
end

local function resize_window(win, buf)
  if not api.nvim_win_is_valid(win) then
    -- Could happen if the user moves the buffer into a new window
    return
  end
  local lines = api.nvim_buf_get_lines(buf, 0, -1, true)
  local width = 0
  local height = #lines
  for _, line in pairs(lines) do
    width = math.max(width, #line)
  end
  local columns = api.nvim_get_option('columns')
  local max_win_width = math.floor(columns * 0.9)
  width = math.min(width, max_win_width)
  local max_win_height = api.nvim_get_option('lines')
  height = math.min(height, max_win_height)
  api.nvim_win_set_width(win, width)
  api.nvim_win_set_height(win, height)
end

local function resizing_layer(buf)
  local layer = ui.layer(buf)
  local orig_render = layer.render
  layer.render = function(...)
    orig_render(...)
    local win = find_window(buf)
    if win ~= nil and api.nvim_win_get_config(win).relative ~= '' then
      resize_window(win, buf)
    end
  end
  return layer
end

local function set_default_bufopts(buf)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  api.nvim_buf_set_keymap(
    buf, "n", "<CR>", "<Cmd>lua require('dap.ui').trigger_actions({ mode = 'first' })<CR>", {})
  api.nvim_buf_set_keymap(
    buf, "n", "a", "<Cmd>lua require('dap.ui').trigger_actions()<CR>", {})
  api.nvim_buf_set_keymap(
    buf, "n", "o", "<Cmd>lua require('dap.ui').trigger_actions()<CR>", {})
  api.nvim_buf_set_keymap(
    buf, "n", "<2-LeftMouse>", "<Cmd>lua require('dap.ui').trigger_actions()<CR>", {})
end

local function new_buf()
  local buf = api.nvim_create_buf(false, true)
  set_default_bufopts(buf)
  return buf
end

-- Check if hover and hover.register are available
if hover and type(hover.register) == "function" then
  hover.register {
    name = 'DAP',
    --- @param bufnr integer
    enabled = function(bufnr)
      return dap.session() ~= nil
    end,
    --- @param opts Hover.Options
    --- @param done fun(result: any)
    execute = function(opts, done)
      local buf = new_buf()
      local layer = resizing_layer(buf)
      local fake_view = {
        layer = function ()
          return layer
        end,
      }
      local expression = vim.fn.expand('<cexpr>')
      widgets.expression.render(fake_view, expression)
      done { bufnr = buf }
    end,
    priority = 1002, -- above lsp and diagnostics
  }
else
  print("hover.register is not available. DAP hover functionality will be limited.")
end
