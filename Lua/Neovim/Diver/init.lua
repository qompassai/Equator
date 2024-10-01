-- Base configuration
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Define safe_require function
local function safe_require(module)
  local success, result = pcall(require, module)
  if not success then
    vim.api.nvim_err_writeln("Error loading " .. module .. ": " .. result)
  end
  return success, result
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- Load lazy config
local lazy_config = require "configs.lazy"

-- Set up Neovim to use OpenResty's LuaJIT
vim.g.lua_interpreter_path = '/opt/openresty/luajit/bin/luajit'

-- Configure Lua runtime path for Neovim
vim.opt.runtimepath:append("/opt/openresty/lualib")
vim.opt.runtimepath:append("/opt/openresty/luajit/share/luajit-2.1.0-beta3")

-- Set up Lua path for require statements
local lua_path = table.concat({
  "/opt/openresty/lualib/?.lua",
  "/opt/openresty/lualib/?/init.lua",
  vim.fn.expand("~/.luarocks/share/lua/5.1/?.lua"),
  vim.fn.expand("~/.luarocks/share/lua/5.1/?/init.lua"),
  package.path
}, ";")
package.path = lua_path

-- Set up Lua C path for binary modules
local lua_cpath = table.concat({
  "/opt/openresty/lualib/?.so",
  vim.fn.expand("~/.luarocks/lib/lua/5.1/?.so"),
  package.cpath
}, ";")
package.cpath = lua_cpath

-- Optional: Set environment variables within Neovim
vim.env.LUAJIT_LIB = "/opt/openresty/luajit/lib"
vim.env.LUAJIT_INC = "/opt/openresty/luajit/include/luajit-2.1"

-- Rust
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("$HOME/.cargo/bin")

-- Load plugins
require("lazy").setup({
  {"NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins"},
}, lazy_config)

--Theme
local function safe_dofile(file)
  local success, err = pcall(dofile, file)
  if not success then
    vim.api.nvim_err_writeln("Error loading " .. file .. ": " .. err)
  end
end

safe_dofile(vim.g.base46_cache .. "defaults")
safe_dofile(vim.g.base46_cache .. "statusline")

-- Providers
-- Set up providers
vim.g.python3_host_prog = '/usr/bin/python'
vim.g.ruby_host_prog = '/usr/bin/ruby'
vim.g.node_host_prog = '/usr/bin/node'

-- For Rust, you don't need to set a specific provider, but you can set the path for rust-analyzer
vim.g.rustfmt_command = '/usr/bin/rustfmt'

-- For Jupyter, you can set the command path
vim.g.jupyter_command = '/usr/bin/jupyter'

-- For pyenv, you might want to use it to manage Python versions
vim.env.PYENV_ROOT = os.getenv("HOME") .. "/.pyenv"
vim.env.PATH = vim.env.PYENV_ROOT .. "/bin:" .. vim.env.PATH

-- Cargo is typically used by Rust plugins, so you don't need to set it explicitly
-- but you can ensure it's in your PATH
vim.env.PATH = vim.env.PATH .. ":/usr/bin"


-- Autocmds
require "autocmds"



safe_require "options"
safe_require "mappings"
