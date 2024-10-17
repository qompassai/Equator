return
{
        "williamboman/mason.nvim",
        lazy = true,
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
        opts = function()
            return require "configs.mason"
        end,
        lazy = true,
    }
