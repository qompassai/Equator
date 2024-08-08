-- Set custom directories for swap and undo files
vim.opt.directory = vim.fn.stdpath("data") .. "/swapfiles//"
vim.opt.undodir = vim.fn.stdpath("data") .. "/undofiles//"
vim.opt.undofile = true

-- Base configuration
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- Create necessary directories
local function ensure_directory(path)
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end
end

ensure_directory(vim.fn.stdpath("data") .. "/swapfiles")
ensure_directory(vim.fn.stdpath("data") .. "/undofiles")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)
-- providers
vim.g.loaded_node_provider = 1
vim.g.loaded_perl_provider = 1
vim.g.loaded_python3_provider = 1
vim.g.loaded_ruby_provider = 1
-- Load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Additional Neovim settings
vim.opt.backup = false  -- Disable backup files
vim.opt.writebackup = false  -- Disable backup files during write
vim.opt.swapfile = false  -- Keep swap files enabled (change to false if you want to disable)

-- Error handling for theme loading
local function safe_require(module)
    local success, result = pcall(require, module)
    if not success then
        vim.api.nvim_err_writeln("Error loading " .. module .. ": " .. result)
    end
    return success, result
end

safe_require("options")
safe_require("mappings")

