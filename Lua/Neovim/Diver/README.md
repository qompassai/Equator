**This repo is supposed to used as config by NvChad users!**

## Diver IDE structure

```bash
~/.config/nvim
├── init.lua
├── lazy-lock.json
├── LICENSE
├── lua
│ ├── autocmds.lua
│ ├── chadrc.lua
│ ├── configs
│ │ ├── cmp.lua
│ │ ├── conform.lua
│ │ ├── gitsigns.lua
│ │ ├── lazy.lua
│ │ ├── lazy_nvim.lua
│ │ ├── lspconfig.lua
│ │ ├── luasnip.lua
│ │ ├── mason.lua
│ │ ├── nvimtree.lua
│ │ ├── telescope.lua
│ │ └── treesitter.lua
│ ├── core
│ │ ├── mappings.lua
│ │ └── utils.lua
│ ├── mappings.lua
│ ├── options.lua
│ └── plugins
│   └── init.lua
└── README.md
```

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
