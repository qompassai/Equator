return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup {
        override = {
          zsh = {
            icon = " ",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh",
          },
          lua = {
            icon = " ",
            color = "#56b6c2",
            cterm_color = "74",
            name = "Lua",
          },
          python = {
            icon = " ",
            color = "#3572A5",
            cterm_color = "67",
            name = "Python",
          },
          javascript = {
            icon = " ",
            color = "#f7df1e",
            cterm_color = "220",
            name = "JavaScript",
          },
          svelte = {
            icon = " ",
            color = "#ff3e00",
            cterm_color = "202",
            name = "Svelte",
          },
          rust = {
            icon = "",
            color = "#dea584",
            cterm_color = "173",
            name = "Rust",
          },
          sqls = {
            icon = " ",
            color = "#dad8d8",
            cterm_color = "250",
            name = "SQL",
          },
          terraform = {
            icon = " ",
            color = "#5c4ee5",
            cterm_color = "99",
            name = "Terraform",
          },
          docker = {
            icon = " ",
            color = "#2496ed",
            cterm_color = "33",
            name = "Docker",
          },
          vim = {
            icon = " ",
            color = "#019833",
            cterm_color = "28",
            name = "VimLanguageServer",
          },
          tailwindcss = {
            icon = "󰞁 ",
            color = "#38bdf8",
            cterm_color = "39",
            name = "TailwindCSS",
          },
          typescript = {
            icon = " ",
            color = "#3178c6",
            cterm_color = "68",
            name = "TypeScript",
          },
          json = {
            icon = "ﬥ",
            color = "#cbcb41",
            cterm_color = "185",
            name = "Json",
          },
          css = {
            icon = " ",
            color = "#563d7c",
            cterm_color = "60",
            name = "CSS",
          },
          html = {
            icon = " ",
            color = "#e44d26",
            cterm_color = "202",
            name = "HTML",
          },
          markdown = {
            icon = " ",
            color = "#519aba",
            cterm_color = "67",
            name = "Markdown",
          },
          tex = {
            icon = " ",
            color = "#3d6117",
            cterm_color = "64",
            name = "TeX",
          },
          go = {
            icon = " ",
            color = "#00ADD8",
            cterm_color = "38",
            name = "Go",
          },
          yaml = {
            icon = " ",
            color = "#6e9fda",
            cterm_color = "39",
            name = "Yaml",
          },
          thrift = {
            icon = " ",
            color = "#D12127",
            cterm_color = "167",
            name = "Thrift",
          },
          jupyter = {
            icon = " ",
            color = "#f28e1c",
            cterm_color = "214",
            name = "Jupyter",
          },
          vimls = {
            icon = " ",
            color = "#019833",
            cterm_color = "28",
            name = "VimLanguageServer",
          },
          stylua = {
            icon = " ",
            color = "#56b6c2",
            cterm_color = "74",
            name = "Stylua",
          },
          tfsec = {
            icon = " ",
            color = "#f30067",
            cterm_color = "197",
            name = "TFSec",
          },
        },
        default = true,
        color_icons = true,
      }
      vim.cmd [[
        augroup DevIconsRefresh
          autocmd!
          autocmd BufEnter * lua require("nvim-web-devicons").refresh()
        augroup END
      ]]
    end,
  },
  {
    "yamatsum/nvim-nonicons",
    lazy = true,
    config = function()
      require("nvim-nonicons").setup {
        default = false,
        icons = {
          file = " ",
          folder = " ",
          git_branch = " ",
          cloud = " ",
          data = " ",
          ai = "ﮧ",
          edu = " ",
          rust = " ",
          lua = " ",
          py = " ",
          js = " ",
          docker = " ",
          markdown = " ",
          toml = " ",
          sh = " ",
          go = " ",
          zig = "  ",
          yaml = " ",
          json = "ﬥ",
        },
      }
    end,
  },
}
