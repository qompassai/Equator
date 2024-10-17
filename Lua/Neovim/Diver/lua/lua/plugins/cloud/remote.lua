return {
  "amitds1997/remote-nvim.nvim",
  lazy = true,  -- Enable lazy loading
  version = "*",  -- Pin to GitHub releases
  dependencies = {
    "nvim-lua/plenary.nvim",  -- For standard functions
    "MunifTanjim/nui.nvim",  -- To build the plugin UI
    "nvim-telescope/telescope.nvim",  -- For picking between different remote methods
  },
  config = function()
    require('remote-nvim').setup {
      method = "ssh",  -- Set default remote method to SSH
      default_user = os.getenv("USER"),  -- Use the current system user as default
      picker = "telescope",  -- Use Telescope to pick the remote
      ssh_config = vim.fn.expand("~/.ssh/config"),  -- Use custom SSH config for remote servers
    }
  end,
  event = "VeryLazy",  -- Load the plugin lazily based on an event (change as required)
}

