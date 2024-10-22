return {
  "folke/noice.nvim",
  lazy = false,
  event = "VeryLazy",
  opts = {
    lsp = {
      -- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = false,  -- Enable enhanced hover UI with Treesitter support
      },
      signature = {
        enabled = false,  -- Enable enhanced signature help using Treesitter
        auto_open = {
          enabled = false,
          trigger = false,
          luasnip = true, -- Open signature help when jumping to Luasnip insert nodes
          throttle = 50,  -- Debounce LSP signature help request by 50ms
        },
        view = nil,
        routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "which%-key",
        },
        opts = { skip = true },
      },
    },
  },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        relative = "editor",
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
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
