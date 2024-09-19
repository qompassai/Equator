return {
  "nvimtools/none-ls.nvim",
  lazy = false,
  dependencies = {
    "davidmh/cspell.nvim",
    "gbprod/none-ls-shellcheck.nvim",
    "gbprod/none-ls-luacheck.nvim",
    "gbprod/none-ls-php.nvim",
    "gbprod/none-ls-psalm.nvim",
    "gbprod/none-ls-ecs.nvim",
    "mfussenegger/nvim-dap",
    {"mrcjkb/rustaceanvim",
    version = "^5",
      ft = {"rust"},
    },
    "neovim/nvim-lspconfig",
    "nvimtools/none-ls-extras.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "Zeioth/none-ls-external-sources.nvim",
  },
  config = function()
    require("null-ls").setup()
  local null_ls = require("null-ls")

  null_ls.setup({
  sources = {


        --Make--

  --checkmake | make linter.
        null_ls.builtins.diagnostics.checkmake.with({
    ft = {"make"},
    cmd = {"checkmake"},
    extra_args = {"--format='{{.LineNumber}}:{{.Rule}}:{{.Violation}}\n'", "$FILENAME"},
  }),

        -- Grammar/spelling --

      --spell | Spell suggestions completion source.
        null_ls.builtins.completion.spell.with({
          ft = {""},
        }),
        --dictionary |Shows the first available definition for the current word under the cursor.
        null_ls.builtins.hover.dictionary.with({
          ft = {"org", "text", "markdown"},
        }),


        --Git--
    --Gitsigns | Injects code actions for Git operations at the current cursor position (stage / preview / reset hunks, blame, etc.).
      gitsigns = null_ls.builtins.code_actions.gitsigns.with({
    config = {
        filter_actions = function(title)
            return title:lower():match("blame") == nil -- filter out blame actions
        end,
    },
}),
    --Gitrebase | Injects actions to change gitrebase command (e.g. using squash instead of pick).
        null_ls.builtins.code_actions.gitrebase.with({
    filetypes = {"gitrebase"},
  }),

        -- Go--
    --gofmt | Formats go programs.
        null_ls.builtins.formatting.gofmt.with({
    filetypes = {"go"},
    command = {"gofmt"},
  }),

        --gomodifytags | Go tool to modify struct field tags
        null_ls.builtins.code_actions.gomodifytags,
        --golangcli_lint | A go linter aggregator
        null_ls.builtins.diagnostics.golangci_lint.with({
          ft = {"go"},
          cmd = {"golangcli-lint"},
          extra_args = {"run", "--fix=false", "--out-format=json"},
        }),
        --revive | Fast, configurable, extensible, flexible, and beautiful linter for Go.
        null_ls.builtins.diagnostics.revive.with({
          ft = {"go"},
          cmd = {"revive"},
          extra_args ={"-formatter", "json", "./..."},
        }),

        --Groovy--

        --npm_groovy_lint | Lint, format and auto-fix Groovy, Jenkinsfile, and Gradle files.
        null_ls.builtins.diagnostics.npm_groovy_lint.with({
        filetypes = {"groovy", "java", "Jenkinsfile"},
        command = {"npm_groovy_lint"},
        extra_args = {"-o", "json", "-"},
      }),

        --Html--

        --Tidy corrects and cleans up HTML and XML documents by fixing markup errors and upgrading legacy code to modern standards.
        null_ls.builtins.formatting.tidy.with({
      ft = {"html", "xml"},
      cmd = {"tidy"},
      extra_args = {"--tidy-mark", "no", "-quiet", "-indent", "-wrap", "-"}
    }),

      --Lua--

    --stylua | An opinionated code formatter for Lua.
    null_ls.builtins.formatting.stylua.with({
    filetypes = {"lua", "luau"},
    command = {"stylua"},
  }),

    --luasnip | Snippet engine for Neovim, written in Lua.
  null_ls.builtins.completion.luasnip.with({
        ft = {""},
      }),
  require("none-ls-luacheck.diagnostics.luacheck"),


        --Java--
        null_ls.builtins.diagnostics.checkstyle.with({
          extra_args = { "-c", "/google_checks.xml" },
        }),

        --Javascript--

        --prettierd | prettier, as a daemon, for ludicrous formatting speed.
        null_ls.builtins.formatting.prettierd.with({
        filetypes =  {"javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml", "markdown", "markdown.mdx", "graphql", "handlebars", "svelte", "astro", "htmlangular"},
        cmd = {"prettierd"},
      }),

      require("none-ls.diagnostics.eslint"),
      require("none-ls-ecs.formatting"),
        null_ls.builtins.formatting.biome.with({
          ft = {"javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
          cmd = {"biome"},
          extra_args = { "format", "--stdin-file-path", "$FILENAME" },
        }),

        --Markdown
        --markdownlint | Markdown style and syntax checker
        null_ls.builtins.formatting.markdownlint.with({
          ft = {"markdown"},
          cmd = {"markdownlint"},
        }),
        --markdownlint_cli2 | A fast, flexible, configuration-based command-line interface for linting Markdown/CommonMark files with the markdownlint library.
        null_ls.builtins.diagnostics.markdownlint_cli2.with({
          ft = {"markdown"},
        cmd = {"markdownlint-cli2"}
        }),
        --spell | Spell suggestions completion source.
        null_ls.builtins.completion.spell.with({
          ft = {""},
        }),
        --markuplint | --A linter for all markup developers.
        null_ls.builtins.diagnostics.markuplint.with({
          ft = {"html"},
          cmd = {"markuplint"},
          extra_args = {"--format", "JSON", "$FILENAME"},
        }),
        --mdl | A tool to check Markdown files and flag style issues.
        null_ls.builtins.diagnostics.mdl.with({
          ft = {"markdown"},
          cmd = {"mdl"},
          extra_args ={"--json"},
        }),
        --textlint | The pluggable linting tool for text and Markdown.
        null_ls.builtins.formatting.textlint.with({
          ft = {"txt", "markdown"},
          cmd = {"textlint"},
        }),


        --MATLAB--
        null_ls.builtins.diagnostics.mlint,

        --PHP
        require("none-ls-php.diagnostics.php"),
        require("none-ls-psalm.diagnostics"),
      --PHP_CodeSniffer is a script that tokenizes PHP, JavaScript and CSS files to detect violations of a defined coding standard.
        null_ls.builtins.diagnostics.phpcs,

      --Python--

      --black | The uncompromising Python code formatter
        null_ls.builtins.formatting.black.with({
          ft = {"python"},
          cmd = {"black"},
        }),
      --blackd |
        null_ls.builtins.formatting.blackd.with({
          ft = {"python"},
        }),
      --mypy | An optional static type checker for Python that aims to combine the benefits of dynamic (or "duck") typing and static typing.
        null_ls.builtins.diagnostics.mypy.with({
        filetypes = {"python"},
        command = {"mypy"},
      }),
    --pylint | is a Python static code analysis tool which looks for programming errors, helps enforcing a coding standard, sniffs for code smells and offers simple refactoring suggestions.
        null_ls.builtins.diagnostics.pylint.with({
      ft = {"python"},
      command = {"pylint"},
    }),
    --isort | Python utility / library to sort imports alphabetically and automatically separate them into sections and by type.
        null_ls.builtins.formatting.isort.with({
            ft = {"python"},
            cmd = {"isort"},
          extra_args = {"--stdout", "--filename", "$FILENAME", "-"},
            }),

        --Ruby--

        --rubyfmt | Format your ruby code!
        null_ls.builtins.formatting.rubyfmt.with({
            ft = {"ruby"},
            cmd = {"rubyfmt"},
        }),
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.formatting.rubocop,
        --Regal is a linter for Rego, with the goal of making your Rego magnificent!.
        null_ls.builtins.diagnostics.regal.with({
            ft = {"rego"},
            cmd = {"regal"},
        }),

        --Rust--

        --LanguageTool-Rust (LTRS) is both an executable and a Rust library that aims to provide correct and safe bindings for the LanguageTool API.
        null_ls.builtins.diagnostics.ltrs.with({
            ft = {"text", "markdown", "markdown"},
            cmd = {"ltrs"},
        }),

        --Shell--

        --shellharden | Hardens shell scripts by quoting variables, replacing function_call with $(function_call), and more.
        null_ls.builtins.formatting.shellharden.with({
            filetypes = {"sh"},
            cmd = {"shellharden"},
          }),
        null_ls.builtins.formatting.shfmt.with({
      ft = {"sh"},
      cmd = {"shfmt"},
      extra_args = { "-i", "2", "-ci" },
    }),
    }
    })
    end,
  requires = {"nvim-lua/plenary.nvim" },
  }
