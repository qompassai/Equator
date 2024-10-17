-- Jupyter Plugin Group

return {
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
    lazy = false,
  },
  {
  "kiyoon/jupynium.nvim",
  lazy = false,
  build = "pip3 install --user . --break-system-packages",
  -- If using conda, use this build command instead:
  -- build = "conda run --no-capture-output -n jupynium pip install .",
  dependencies = {
    "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
  },
  config = function()
    require("jupynium").setup({})
  end,
},
}

