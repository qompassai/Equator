return {
  -- Configuration for devpod connections
  devpod = {
    binary = "devpod", -- Binary to use for devpod
    docker_binary = "docker", -- Binary to use for docker-related commands
    ---@diagnostic disable-next-line:param-type-mismatch
    ssh_config_path = utils.path_join(utils.is_windows, vim.fn.stdpath("data"), constants.PLUGIN_NAME, "ssh_config"), -- Path where devpod SSH configurations should be stored
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
    ssh_config_file_paths = { "$HOME/.ssh/config" }, -- Which files will contain ssh host configurations.
        NOTE: `Include` is respected in the provided files.

    -- These are useful for password-based SSH authentication.
    -- It provides parsing pattern for the plugin to detect that an input is requested.
    -- Each element contains the following attributes:
    -- match - The string to match (plain matching is done)
    -- type - Supports two values "plain"|"secret". 
        -- Secret means when you provide the value.
    -- it should NOT be stored in the completion history of Neovim.
    -- value - Default value for the prompt
    -- value_type - "static"|"dynamic". 
        -- Needed for things like password, it would be needed for each new connection that the plugin initiates which could be obtrusive.
    -- So, we save the value (only for current session's interval) to ease the process. 
    -- If set to "dynamic", we do not save the value even for the session. 
    -- You have to provide a fresh value each time.
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
      -- There are other values here which can be checked in lua/remote-nvim/init.lua
    },
  },

  -- Path to the script that would be copied to the remote and called to ensure that neovim gets installed.
  -- Default path is to the plugin's own ./scripts/neovim_install.sh file.
  neovim_install_script_path = utils.path_join(
    utils.is_windows,
    vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h:h:h"),
    "scripts",
    "neovim_install.sh"
  ),

  -- Modify the UI for the plugin's progress viewer.
  -- type can be "split" or "popup". All options from https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup and https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/split are supported.
  -- Note that some options like "border" are only available for "popup".
  progress_view = {
    type = "popup",
  },


  -- Offline mode configuration. For more details, see the "Offline mode" section below.
  offline_mode = {
    -- Should offline mode be enabled?
    enabled = false,
    -- Do not connect to GitHub at all. Not even to get release information.
    no_github = false,
    -- What path should be looked at to find locally available releases
    cache_dir = utils.path_join(utils.is_windows, vim.fn.stdpath("cache"), constants.PLUGIN_NAME, "version_cache"),
  },

  -- Remote configuration
  remote = {
    app_name = "nvim", -- This directly maps to the value NVIM_APPNAME. If you use any other paths for configuration, also make sure to set this.
    -- List of directories that should be copied over
    copy_dirs = {
      -- What to copy to remote's Neovim config directory
      config = {
        base = vim.fn.stdpath("config"), -- Path from where data has to be copied
        dirs = "*", -- Directories that should be copied over. "*" means all directories. To specify a subset, use a list like {"lazy", "mason"} where "lazy", "mason" are subdirectories
        -- under path specified in `base`.
        compression = {
          enabled = false, -- Should compression be enabled or not
          additional_opts = {} -- Any additional options that should be used for compression. Any argument that is passed to `tar` (for compression) can be passed here as separate elements.
        },
      },
      -- What to copy to remote's Neovim data directory
      data = {
        base = vim.fn.stdpath("data"),
        dirs = {},
        compression = {
          enabled = true,
        },
      },
      -- What to copy to remote's Neovim cache directory
      cache = {
        base = vim.fn.stdpath("cache"),
        dirs = {},
        compression = {
          enabled = true,
        },
      },
      -- What to copy to remote's Neovim state directory
      state = {
        base = vim.fn.stdpath("state"),
        dirs = {},
        compression = {
          enabled = true,
        },
      },
    },
  },

  -- You can supply your own callback that should be called to create the local client. This is the default implementation.
  -- Two arguments are passed to the callback:
  -- port: Local port at which the remote server is available
  -- workspace_config: Workspace configuration for the host. For all the properties available, see https://github.com/amitds1997/remote-nvim.nvim/blob/main/lua/remote-nvim/providers/provider.lua#L4
  -- A sample implementation using WezTerm tab is at: https://github.com/amitds1997/remote-nvim.nvim/wiki/Configuration-recipes
  client_callback = function(port, _)
    require("remote-nvim.ui").float_term(("nvim --server localhost:%s --remote-ui"):format(port), function(exit_code)
      if exit_code ~= 0 then
        vim.notify(("Local client failed with exit code %s"):format(exit_code), vim.log.levels.ERROR)
      end
    end)
  end,

  -- Plugin log related configuration [PREFER NOT TO CHANGE THIS]
  log = {
    -- Where is the log file
    filepath = utils.path_join(utils.is_windows, vim.fn.stdpath("state"), ("%s.log"):format(constants.PLUGIN_NAME)),
    -- Level of logging
    level = "info",
    -- At what size, should we truncate the logs
    max_size = 1024 * 1024 * 2, -- 2MB
  },
}
