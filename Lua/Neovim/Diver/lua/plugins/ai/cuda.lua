return {
    {
        "bfrg/vim-cuda-syntax",
        lazy = true,
        ft = { "cuda" },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        opts = function()
            local lspconfig = require("lspconfig")
            lspconfig.clangd.setup({
                filetypes = { "c", "cpp", "cuda" },
                cmd = { "clangd", "--background-index" },
            })
        end,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim"
        },
    },
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        opts = function()
            local dap = require("dap")
            dap.adapters.cpp = {
                type = 'executable',
                command = 'lldb-vscode',
                name = "lldb"
            }
            dap.configurations.cuda = {
                {
                    name = "Launch CUDA Program",
                    type = "cpp",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }
        end,
        dependencies = {
            "williamboman/mason.nvim",
            "rcarriga/nvim-dap-ui",
        },
        lazy = true,
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                cuda = { "clang-format" },
            },
        },
        lazy = true,
    },
    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        dependencies = "rafamadriz/friendly-snippets",
        opts = function()
            local ls = require("luasnip")
            ls.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })
        end,
        config = function()
            require("luasnip.loaders.from_vscode").load({ paths = { "./snippets/cuda" } })
        end,
    },
        {
        "nvim-treesitter/nvim-treesitter",
        opts = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
        build = ":TSUpdate",
        lazy = true,
    },
}

