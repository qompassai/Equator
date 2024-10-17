local utils = require("configs.utils")
local constants = {
    PLUGIN_NAME = "remote-nvim"
}

-- Determine the appropriate SSH config path
local ssh_config_path
if vim.fn.filereadable(vim.fn.expand("~/.ssh/config")) == 1 then
    ssh_config_path = vim.fn.expand("~/.ssh/config")
else
    ssh_config_path = "/etc/ssh/ssh_config"
end

return {
    -- Configuration for devpod connections
    devpod = {
        binary = "devpod", -- Binary to use for devpod
        docker_binary = "docker", -- Binary to use for docker-related commands
        ssh_config_path = ssh_config_path,  -- Path chosen based on availability
        search_style = "current_dir_only", -- How should devcontainers be searched
        -- For dotfiles, see https://devpod.sh/docs/developing-in-workspaces/dotfiles-in-a-workspace for more information
        dotfiles = {
            path = nil, -- Path to your dotfiles which should be copied into devcontainers
            install_script = nil -- Install script that should be called to install your dotfiles
        },
        gpg_agent_forwarding = false, -- Should GPG agent be forwarded over the network
        container_list = "running_only", -- How should docker list containers ("running_only" or "all")
    },
    -- Configuration for SSH connections
    ssh_config = {
        ssh_binary = "ssh", -- Binary to use for running SSH command
        scp_binary = "scp", -- Binary to use for running SSH copy commands
        ssh_config_file_paths = { ssh_config_path }, -- Path to SSH configuration.
        ssh_prompts = {
            {
                match = "password:",
                type = "secret",
                value_type = "static",
                value = "",
            },
            {
                match = "continue connecting (yes/no/[fingerprint])?",
                type = "plain",
                value_type = "static",
                value = "",
            },
        },
    },

    -- Path to the script that would be copied to the remote and called to ensure that neovim gets installed.
    -- Default path is to the plugin's own ./scripts/neovim_install.sh file.
    neovim_install_script_path = utils.path_join(
        vim.fn.stdpath("config"),
        "lua/plugins/cloud/remote.lua",  -- Replace this with your desired path if necessary
        "scripts",
        "neovim_install.sh"
    ),

    -- Modify the UI for the plugin's progress viewer.
    progress_view = {
        type = "popup",
    },

    -- Offline mode configuration.
    offline_mode = {
        enabled = false,
        no_github = false,
        cache_dir = utils.path_join(vim.fn.stdpath("cache"), constants.PLUGIN_NAME, "version_cache"),
    },

    -- Remote configuration
    remote = {
        app_name = "nvim",
        copy_dirs = {
            config = {
                base = vim.fn.stdpath("config"),
                dirs = "*",
                compression = {
                    enabled = false,
                    additional_opts = {}
                },
            },
            data = {
                base = vim.fn.stdpath("data"),
                dirs = {},
                compression = {
                    enabled = true,
                },
            },
            cache = {
                base = vim.fn.stdpath("cache"),
                dirs = {},
                compression = {
                    enabled = true,
                },
            },
            state = {
                base = vim.fn.stdpath("state"),
                dirs = {},
                compression = {
                    enabled = true,
                },
            },
        },
    },

    -- Callback for creating the local client.
    client_callback = function(port, _)
        require("remote-nvim.ui").float_term(("nvim --server localhost:%s --remote-ui"):format(port), function(exit_code)
            if exit_code ~= 0 then
                vim.notify(("Local client failed with exit code %s"):format(exit_code), vim.log.levels.ERROR)
            end
        end)
    end,

    -- Plugin log related configuration
    log = {
        filepath = utils.path_join(vim.fn.stdpath("state"), ("%s.log"):format(constants.PLUGIN_NAME)),
        level = "info",
        max_size = 1024 * 1024 * 2,
    },
}

