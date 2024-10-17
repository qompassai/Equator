return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        lazy = true,
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("configs.luasnip")
        end,
      },
      {
        "windwp/nvim-autopairs",
        lazy = true,
        event = "InsertEnter",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
      {
        "saadparwaiz1/cmp_luasnip",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-nvim-lua",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-nvim-lsp",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-buffer",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-path",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-calc",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "f3fora/cmp-spell",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "ray-x/cmp-treesitter",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "kdheepak/cmp-latex-symbols",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "jmbuhr/cmp-pandoc-references",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "onsails/lspkind-nvim",
        lazy = true,
        event = "InsertEnter",
      },
      {
        "jmbuhr/otter.nvim",
        lazy = true,
        event = "InsertEnter",
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = {
          ["<C-f>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<c-y>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        },
        autocomplete = true,
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            menu = {
              otter = "[🦦]",
              nvim_lsp = "[LSP]",
              nvim_lsp_signature_help = "[sig]",
              luasnip = "[snip]",
              buffer = "[buf]",
              path = "[path]",
              spell = "[spell]",
              pandoc_references = "[ref]",
              tags = "[tag]",
              treesitter = "[TS]",
              calc = "[calc]",
              latex_symbols = "[tex]",
              emoji = "[emoji]",
            },
          }),
        },
        sources = {
          { name = "otter" },
          { name = "path" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "luasnip", keyword_length = 3, max_item_count = 3 },
          { name = "pandoc_references" },
          { name = "buffer", keyword_length = 5, max_item_count = 3 },
          { name = "spell" },
          { name = "treesitter", keyword_length = 5, max_item_count = 3 },
          { name = "calc" },
          { name = "latex_symbols" },
          { name = "emoji" },
        },
        view = {
          entries = "native",
        },
      })

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
      luasnip.filetype_extend("quarto", { "markdown" })
      luasnip.filetype_extend("rmarkdown", { "markdown" })
    end,
  },
}

