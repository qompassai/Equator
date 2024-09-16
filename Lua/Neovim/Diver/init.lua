local vim = vim or require "vim"

-- swap and undo files
vim.g.directory = vim.fn.stdpath "data" .. "/swapfiles//"
vim.g.undodir = vim.fn.stdpath "data" .. "/undofiles//"
vim.g.undofile = true
-- luarocks
local home = os.getenv "HOME"
package.path = home .. "/.luarocks/share/lua/5.4/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.4/?.so;" .. package.cpath
-- Base configuration
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- Create necessary directories
local function ensure_directory(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end
-- python
vim.g.python3_host_prog = "/usr/bin/python3"
ensure_directory(vim.fn.stdpath "data" .. "/swapfiles")
ensure_directory(vim.fn.stdpath "data" .. "/undofiles")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- Load lazy config
local lazy_config = require "configs.lazy"

-- Load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- providers
vim.g.python3_host_prog = "/bin/python3"
vim.g.node_host_prog = "/bin/node"
vim.g.perl_host_prog = "/bin/perl"
vim.g.ruby_host_prog = "/bin/ruby"
vim.g.ruby_host_prog = "/bin/jupyter"
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.jupyter_highlight_cells = 0
-- theme
local function safe_dofile(file)
  local success, err = pcall(dofile, file)
  if not success then
    vim.api.nvim_err_writeln("Error loading " .. file .. ": " .. err)
  end
end

safe_dofile(vim.g.base46_cache .. "defaults")
safe_dofile(vim.g.base46_cache .. "statusline")

-- autocmds
require "autocmds"

-- mappings
vim.schedule(function()
  require "mappings"
end)

-- Additional Neovim settings
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Error handling for module loading
local function safe_require(module)
  local success, result = pcall(require, module)
  if not success then
    vim.api.nvim_err_writeln("Error loading " .. module .. ": " .. result)
  end
  return success, result
end

safe_require "options"
safe_require "mappings"
