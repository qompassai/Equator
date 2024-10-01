return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = true,
      },
      signature = {
        enabled = false,
        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
        view = nil, -- when nil, use defaults from documentation
        opts = {}, -- merged with defaults from documentation
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    views = {
      cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
     cmdline = {
      enabled = true,
      view = "cmdline_popup",
      opts = {},
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        input = {},
        -- Add the new Mason and None-ls formats
        mason = { pattern = "^:Mason", icon = "", lang = "vim" },
        mason_install = { pattern = "^:MasonInstall", icon = "", lang = "vim" },
        mason_update = { pattern = "^:MasonUpdate", icon = "", lang = "vim" },
        none_ls = { pattern = "^:NullLs", icon = "", lang = "vim" },
      },
    },
    -- Add the new routes configuration
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "Mason",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "NullLs",
        },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {"rcarriga/nvim-notify",
            lazy = true,
        },
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
  -- Add the config function
  config = function(_, opts)
    require("noice").setup(opts)
    require("notify").setup({
  -- other options...
  on_open = function(win)
    vim.api.nvim_win_set_option(win, "winhl", "Normal:MyNotifyBackground")
  end,
  background_colour = function()
    return "#000000"
  end,
  -- Add your highlight groups here
  highlights = {
    NotifyERRORBorder = { guifg = "#8A1F1F" },
    NotifyWARNBorder = { guifg = "#79491D" },
    NotifyINFOBorder = { guifg = "#4F6752" },
    NotifyDEBUGBorder = { guifg = "#8B8B8B" },
    NotifyTRACEBorder = { guifg = "#4F3552" },
    NotifyERRORIcon = { guifg = "#F70067" },
    NotifyWARNIcon = { guifg = "#F79000" },
    NotifyINFOIcon = { guifg = "#A9FF68" },
    NotifyDEBUGIcon = { guifg = "#8B8B8B" },
    NotifyTRACEIcon = { guifg = "#D484FF" },
    NotifyERRORTitle = { guifg = "#F70067" },
    NotifyWARNTitle = { guifg = "#F79000" },
    NotifyINFOTitle = { guifg = "#A9FF68" },
    NotifyDEBUGTitle = { guifg = "#8B8B8B" },
    NotifyTRACETitle = { guifg = "#D484FF" },
    -- The body highlights are linked to Normal in your original config
  },
})
    -- Ensure Mason commands are available
    vim.api.nvim_create_user_command("Mason", function() require("mason.ui").open() end, {})
    vim.api.nvim_create_user_command("MasonInstall", function(args) require("mason.api.command").MasonInstall(args.fargs) end, { nargs = "+" })
    vim.api.nvim_create_user_command("MasonUpdate", function() require("mason.api.command").MasonUpdate() end, {})
    -- Add None-ls commands if needed
    vim.api.nvim_create_user_command("NullLsInfo", function() require("null-ls").info() end, {})
    -- Add shellharden command
    vim.api.nvim_create_user_command("Shellharden", function(args)
    local filename = args.args
    if filename == "" then
      filename = vim.fn.expand("%")
    end
    vim.fn.system("shellharden --transform " .. filename)
    vim.cmd("edit!")
  end, { nargs = "?" })

  end,
}
