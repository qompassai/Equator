-- Jupyter Plugin Group

return {
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
    lazy = false,
  },
  {
  "hkupty/iron.nvim",
  config = function()
    require("iron.core").setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          python = {
            command = {"ipython"}
          },
        },
        repl_open_cmd = "vertical botright 100 split"
      },
      keymaps = {
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_mark = "<space>sm",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
      },
    })
  end,
  },
  {
  "kiyoon/jupynium.nvim",
  lazy = false,
  build = "pip3 install --user . --break-system-packages",
  dependencies = {
    "stevearc/dressing.nvim",  },
  config = function()
    require("jupynium").setup({})
  end,
},
}
 -- optional, UI for :JupyniumKernelSelect

