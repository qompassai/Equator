-- navmap.lua

local lspmap = {}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

--null-ls
local null_ls = require "null-ls"

map("n", "<leader>tn", function()
  if null_ls.is_registered "diagnostics" then
    null_ls.disable "diagnostics"
    print "null-ls diagnostics disabled"
  else
    null_ls.enable "diagnostics"
    print "null-ls diagnostics enabled"
  end
end, { desc = "Toggle null-ls diagnostics" })

-- mason-null-ls
local _ = require('mason-core.functional')
local Optional = require('mason-core.optional')

---Maps null_ls source name to its corresponding package name.

local null_ls_to_package = {
	['cmake_lint'] = 'cmakelint',
	['cmake_format'] = 'cmakelang',
	['eslint_d'] = 'eslint_d',
	['goimports_reviser'] = 'goimports_reviser',
	['phpcsfixer'] = 'php-cs-fixer',
	['verible_verilog_format'] = 'verible',
	['lua_format'] = 'luaformatter',
	['ansiblelint'] = 'ansible-lint',
	['deno_fmt'] = 'deno',
	['ruff_format'] = 'ruff',
	['xmlformat'] = 'xmlformatter',
}

local package_to_null_ls = _.invert(null_ls_to_package)
local M = {}
---@param source string: Source Name from NullLs
---@return string: Package Name from Mason
M.getPackageFromNullLs = _.memoize(function(source)
	return Optional.of_nilable(null_ls_to_package[source]):or_else_get(_.always(source:gsub('%_', '-')))
end)

---@param package string: Package Name from Mason
---@return string: NullLs Source Name
M.getNullLsFromPackage = _.memoize(function(package)
	return Optional.of_nilable(package_to_null_ls[package]):or_else_get(_.always(package:gsub('%-', '_')))
end)

--lsp diag
map("n", "<leader>tl", function()
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    vim.diagnostic.enable(false)
    for _, client in ipairs(clients) do
      client.stop()
    end
    print "LSP diagnostics disabled"
  else
    vim.diagnostic.enable()
    vim.cmd "LspStart"
    print "LSP diagnostics enabled"
  end
end, { desc = "Toggle LSP diagnostics" })



map("n", "<leader>tn", function()
  if null_ls.is_registered "diagnostics" then
    null_ls.disable "diagnostics"
    print "null-ls diagnostics disabled"
  else
    null_ls.enable "diagnostics"
    print "null-ls diagnostics enabled"
  end
end, { desc = "Toggle null-ls diagnostics" })

-- mason-null-ls
local _ = require('mason-core.functional')
local Optional = require('mason-core.optional')



---Maps null_ls source name to its corresponding package name.

local null_ls_to_package = {
	['cmake_lint'] = 'cmakelint',
	['cmake_format'] = 'cmakelang',
	['eslint_d'] = 'eslint_d',
	['goimports_reviser'] = 'goimports_reviser',
	['phpcsfixer'] = 'php-cs-fixer',
	['verible_verilog_format'] = 'verible',
	['lua_format'] = 'luaformatter',
	['ansiblelint'] = 'ansible-lint',
	['deno_fmt'] = 'deno',
	['ruff_format'] = 'ruff',
	['xmlformat'] = 'xmlformatter',
}

local package_to_null_ls = _.invert(null_ls_to_package)
local M = {}
---@param source string: Source Name from NullLs
---@return string: Package Name from Mason
M.getPackageFromNullLs = _.memoize(function(source)
	return Optional.of_nilable(null_ls_to_package[source]):or_else_get(_.always(source:gsub('%_', '-')))
end)

---@param package string: Package Name from Mason
---@return string: NullLs Source Name
M.getNullLsFromPackage = _.memoize(function(package)
	return Optional.of_nilable(package_to_null_ls[package]):or_else_get(_.always(package:gsub('%-', '_')))
end)

--lsp diag
map("n", "<leader>tl", function()
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    vim.diagnostic.enable(false)
    for _, client in ipairs(clients) do
      client.stop()
    end
    print "LSP diagnostics disabled"
  else
    vim.diagnostic.enable()
    vim.cmd "LspStart"
    print "LSP diagnostics enabled"
  end
end, { desc = "Toggle LSP diagnostics" })

