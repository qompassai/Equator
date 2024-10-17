-- Set leader key
vim.g.mapleader = " "
vim.keymap.set('n', 'gc', '<Nop>', { noremap = true })
vim.keymap.set('n', 'gcc', '<Nop>', { noremap = true })
vim.keymap.set('x', 'gc', '<Nop>', { noremap = true })
vim.keymap.set('o', 'gc', '<Nop>', { noremap = true })
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- providers
 vim.opt.rtp:append(vim.fn.stdpath("config") .. "/lua/providers")
-- Color settings
vim.o.termguicolors = true

--disable whichkey
vim.g.which_key_disable_health_check = 1

-- Define safe_require function
local function safe_require(module)
  if package.loaded[module] then
    return true, package.loaded[module]
  end
  local success, result = pcall(require, module)
  if not success then
    vim.api.nvim_err_writeln("Error loading " .. module .. ": " .. result)
  end
  return success, result
end

-- Check for OpenResty LuaJIT
local has_openresty = vim.loop.fs_stat("/opt/openresty/luajit")

-- Set environment variables within Neovim
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("$HOME/.cargo/bin")
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("$HOME/.npm-global/bin")
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("/usr/bin")
vim.env.PYENV_ROOT = os.getenv("HOME") .. "/.pyenv"
vim.env.PATH = vim.env.PYENV_ROOT .. "/bin:" .. vim.env.PATH

if has_openresty then
  vim.env.LUAJIT_INC = "/opt/openresty/luajit/include/luajit-2.1"
  vim.env.LUAJIT_LIB = "/opt/openresty/luajit/lib"
end

-- Modular plugin paths
local plugin_imports = {
    "plugins.core",
    "plugins.ai",
    "plugins.cloud",
    "plugins.data",
    "plugins.edu",
    "plugins.lang",
    "plugins.nav",
    "plugins.flow",
    "plugins.ui",
}

local plugins = {}
for _, import in ipairs(plugin_imports) do
    if import == "plugins.core" then
        table.insert(plugins, { import = import })
    else
        table.insert(plugins, { import = import, lazy = false })
    end
end

-- Initialize Lazy.nvim with the configured plugins
require("lazy").setup(plugins)

local function load_directory(directory)
        local path = vim.fn.stdpath("config") .. "/lua/" .. directory
        local files = vim.fn.glob(path .. "/*.lua", true, true)
        for _, file in ipairs(files) do
            local module = file:match(".*/lua/(.*)%.lua$"):gsub("/", ".")
            safe_require(module)
        end
    end

    load_directory("helpers")
    safe_require("sources")
    safe_require("autocmds")
    safe_require("options")
    safe_require("mappings")

-- System Language Providers Configuration

------------------------ | System Language Providers | ------------------------

------------------------------- | C/C++ | -------------------------------
vim.g.c_host_prog = "/usr/bin/gcc"
vim.g.cpp_host_prog = "/usr/bin/g++"
------------------------------- | C/C++ | -------------------------------

-------------------------- | C# (Mono or .NET) | --------------------------
vim.g.cs_host_prog = "/usr/bin/csharp"
vim.g.dotnet_host_prog = "/usr/bin/dotnet"
-------------------------- | C# (Mono or .NET) | --------------------------

------------------------------- | CUDA | -------------------------------
vim.g.cuda_host_prog = "/usr/local/cuda/bin/nvcc"
------------------------------- | CUDA | -------------------------------

----------------------------- | Erlang | -----------------------------
vim.g.erlang_host_prog = "/usr/bin/erl"
----------------------------- | Erlang | -----------------------------

----------------------------- | Fortran | -----------------------------
vim.g.fortran_host_prog = "/usr/bin/gfortran"
----------------------------- | Fortran | -----------------------------

------------------------------- | Go | -------------------------------
vim.g.go_host_prog = "/usr/bin/go"
------------------------------- | Go | -------------------------------

------------------------------- | GPG | -------------------------------
vim.g.gpg_host_prog = "/usr/bin/gpg"
------------------------------- | GPG | -------------------------------

----------------------------- | Haskell | -----------------------------
vim.g.haskell_host_prog = "/usr/bin/ghci"
----------------------------- | Haskell | -----------------------------

------------------------------- | Java | -------------------------------
vim.g.java_host_prog = "/usr/bin/java"
------------------------------- | Java | -------------------------------

---------------------- | JavaScript/Node.js | ----------------------
vim.g.node_host_prog = "/usr/bin/node"
---------------------- | JavaScript/Node.js | ----------------------

------------------- | Lua OpenResty Integration (Conditional) | -------------------
-- Uncomment to enable Lua integration with OpenResty.
if has_openresty then
  vim.opt.runtimepath:append("/opt/openresty/lualib")
  vim.opt.runtimepath:append("/opt/openresty/luajit/share/luajit-2.1")
end

-- Set up Lua C path for binary modules conditionally for OpenResty
if has_openresty then
  local lua_cpath = table.concat({
    "/opt/openresty/lualib/?.so",
    vim.fn.expand("~/.luarocks/lib/lua/5.1/?.so"),
    package.cpath,
  }, ";")
  package.cpath = lua_cpath
end

-- Set up Lua path for require statements conditionally for OpenResty
if has_openresty then
  local lua_path = table.concat({
    "/opt/openresty/lualib/?.lua",
    "/opt/openresty/lualib/?/init.lua",
    vim.fn.expand("~/.luarocks/share/lua/5.1/?.lua"),
    vim.fn.expand("~/.luarocks/share/lua/5.1/?/init.lua"),
    package.path,
  }, ";")
  package.path = lua_path
end

-- Set up Neovim to use OpenResty's LuaJIT conditionally
if has_openresty then
  vim.g.lua_interpreter_path = "/opt/openresty/luajit/bin/luajit"
end
------------------- | Lua OpenResty Integration (Conditional) | -------------------

------------------------------- | Lua | -------------------------------
vim.g.lua_host_prog = "/usr/bin/lua"
------------------------------- | Lua | -------------------------------

------------------------------ | Mojo | ------------------------------
vim.g.mojo_host_prog = "/usr/bin/mojo"
------------------------------ | Mojo | ------------------------------

------------------------------ | Nim | ------------------------------
vim.g.nim_host_prog = "/usr/bin/nim"
------------------------------ | Nim | ------------------------------

------------------------------ | OCaml | ------------------------------
vim.g.ocaml_host_prog = "/usr/bin/ocaml"
------------------------------ | OCaml | ------------------------------

------------------------------ | Perl | ------------------------------
vim.g.perl_host_prog = "/usr/bin/perl"
------------------------------ | Perl | ------------------------------

------------------------------ | PHP | ------------------------------
vim.g.php_host_prog = "/usr/bin/php"
------------------------------ | PHP | ------------------------------

--------------------------- | PostgreSQL | ---------------------------
vim.g.postgres_host_prog = "/usr/bin/psql"
--------------------------- | PostgreSQL | ---------------------------

----------------------------- | Python | -----------------------------
vim.g.python3_host_prog = "/usr/bin/python"
----------------------------- | Python | -----------------------------

-------------------------------- | R | --------------------------------
vim.g.r_host_prog = "/usr/bin/R"
-------------------------------- | R | --------------------------------

------------------------------ | Ruby | ------------------------------
vim.g.ruby_host_prog = "/usr/bin/ruby"
------------------------------ | Ruby | ------------------------------

------------------------------ | Rust | ------------------------------
vim.g.rustc_host_prog = "/usr/bin/rustc"
vim.g.rustfmt_command = "/usr/bin/rustfmt"
------------------------------ | Rust | ------------------------------

------------------------------ | Swift | ------------------------------
vim.g.swift_host_prog = "/usr/bin/swift"
------------------------------ | Swift | ------------------------------

------------------------------- | Zig | -------------------------------
vim.g.zig_host_prog = "/usr/local/bin/zig"
------------------------------- | Zig | -------------------------------

----------------- | Jupyter (for IPython Notebook) | -----------------
vim.g.jupyter_command = "/usr/bin/jupyter"
----------------- | Jupyter (for IPython Notebook) | -----------------


