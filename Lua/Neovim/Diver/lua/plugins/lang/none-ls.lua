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
    "mfussenegger/nvim-dap-python",
    "mfussenegger/nvim-dap",
    {
      "leoluz/nvim-dap-go",
      lazy = false,
      ft = "go",
      dependencies = "mfussenegger/nvim-dap",
      config = function(_, opts)
        require("dap-go").setup(opts)
      end,
      {
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust" },
      },
      "nvimtools/none-ls-extras.nvim",
      "nvim-telescope/telescope.nvim",
      {
        "nvim-tree/nvim-tree.lua",
        lazy = true,
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        opts = function()
          return require "configs.nvimtree"
        end,
      },
      "nvim-tree/nvim-web-devicons",
      { "nvim-treesitter/nvim-treesitter" },
      {
        "jvgrootveld/telescope-zoxide",
        dependencies = {
          "nvim-telescope/telescope.nvim",
        },
        config = function()
          require("telescope").load_extension "zoxide"
        end,
        lazy = false,
      },
      {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
        opts = function()
          return require "configs.mason"
        end,
        lazy = true,
      },
      {
        "nvimtools/none-ls.nvim",
        dependencies = {
          "gbprod/none-ls-luacheck.nvim",
        },
      },
      {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        dependencies = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
        },
        config = function()
          require("configs.lspconfig").defaults()
          local mason = require "mason"
          local mason_lspconfig = require "mason-lspconfig"
          local lspconfig = require "lspconfig"

          mason.setup()
          vim.api.nvim_create_user_command("MasonUpdate", function()
            mason.update()
          end, {})
          mason_lspconfig.setup {
            ensure_installed = {
              "pyright",
              "solargraph",
              "ts_ls",
              "gopls",
              "jdtls",
              "clangd",
              "dockerls",
              "docker_compose_language_service",
              "jsonls",
              "yamlls",
              "matlab_ls",
              "r_language_server",
              "efm",
            },
            automatic_installation = true,
          }
          lspconfig.solargraph.setup {}
          lspconfig.ts_ls.setup {}
          lspconfig.gopls.setup {}
          lspconfig.jdtls.setup {}
          lspconfig.clangd.setup {}
          lspconfig.dockerls.setup {}
          lspconfig.docker_compose_language_service.setup {}
          lspconfig.jsonls.setup {}
          lspconfig.yamlls.setup {}

          local home = vim.fn.expand "$HOME"
          lspconfig.pyright.setup {
            settings = {
              python = {
                analysis = {
                  extraPaths = {
                    "/usr/share/jupyter/kernels/python3",
                    home .. "/.local/share/jupyter/kernels/mojo-jupyter-kernel",
                  },
                  typeCheckingMode = "basic",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                },
              },
            },
            filetypes = { "python", "jupyter", "ipynb" },
          }

          -- Octave/MATLAB
          lspconfig.matlab_ls.setup {}
          -- R
          lspconfig.r_language_server.setup {}
          -- Mojo support (experimental)
          lspconfig.efm.setup {
            init_options = { documentFormatting = true },
            filetypes = { "mojo" },
            settings = {
              rootMarkers = { ".git/" },
              languages = {
                mojo = {
                  { formatCommand = "mojo format -", formatStdin = true },
                },
              },
            },
          }
        end,
      },

      "Zeioth/none-ls-external-sources.nvim",
    },
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local mason_lspconfig = require "mason-lspconfig"
      local lspconfig = require "lspconfig"
      local null_ls = require "null-ls"
      local dap = require "dap"

      null_ls.setup {
        debug = true,
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
              vim.lsp.buf.format { bufnr = bufnr }
            end, { desc = "Format current buffer with LSP" })
          end
          print("null-ls attached to buffer " .. bufnr)
        end,
        sources = {

          --.env--

          --dotenv_linter | Lightning-fast linter for .env files.
          require("null_ls").builtins.diagnostics.dotenv_linter.with {
            ft = { "sh" },
            cmd = { "dotenv-linter" },
          },

          --Bazel--
          require("null_ls").builtins.diagnostics.buildifier.with {
            ft = { "bzl" },
            cmd = { "buildifier" },
            extra_args = { "-mode=check", "-lint=warn", "-format=json", "-path=$FILENAME" },
          },

          --Bean--
          null_ls.builtins.diagnostics.bean_check.with {
            ft = { "beancount" },
          },
          --bean_format | bean_format implements right-aligning numbers in a minimal column.
          null_ls.builtins.formatting.bean_format.with {
            ft = { "beancount" },
            cmd = { "bean-format" },
          },

          --BibTeX

          --bibclean | A portable C program that will:
          --pretty-print,
          --syntax check,
          --and generally sort out a BibTeX database file.
          require("null_ls").builtins.formatting.bibclean.with {
            ft = { "bib" },
            cmd = { "bibclean" },
            extra_args = { "-align-equals", "-delete-empty-values" },
          },

          --brighterscript--

          --bslint | A brighterscript CLI tool to lint your code without compiling your project.
          require("null_ls").builtins.diagnostics.bslint.with {
            ft = { "brs" },
            cmd = { "bslint" },
            extra_args = { "--files", "$FILENAME" },
          },

          --buffer--
          require("null_ls").builtins.diagnostics.buf.with {
            ft = { "proto" },
            cmd = { "buf" },
          },
          --buf | A new way of working with Protocol Buffers.
          require("null_ls").builtins.formatting.buf.with {
            ft = { "proto" },
            cmd = { "buf" },
            extra_args = { "format", "-w", "$FILENAME" },
          },

          --CSS--

          --stylint | A linter for the Stylus CSS preprocessor.
          require("null_ls").builtins.diagnostics.stylint.with {
            ft = { "stylus" },
            cmd = { "" },
            extra_args = { "$FILENAME" },
          },

          --C++--

          --cppcheck | A tool for fast static analysis of C/C++ code.
          require("null_ls").builtins.diagnostics.cppcheck.with {
            ft = { "cpp", "c" },
            cmd = { "cppcheck" },
            extra_args = { "--enable=warning,style,performance,portability", "--template=gcc", "$FILENAME" },
          },
          --gccdiag | gccdiag is a wrapper for any C/C++ compiler (gcc, avr-gcc, arm-none-eabi-gcc, etc)
          --that automatically uses the correct compiler arguments for a file in your project by parsing the
          --compile_commands.json file at the root of your project.
          require("null_ls").builtins.diagnostics.gdlint.with {
            ft = { "gdscript" },
            cmd = { "gdlint" },
            extra_args = { "$FILENAME" },
          },

          --Clang--

          --clang_format | Tool to format C/C++/… code according to a set of rules and heuristics.
          require("null_ls").builtins.formatting.clang_format.with {
            ft = { "c", "cpp", "cs", "java", "cuda", "proto" },
            cmd = { "clang-format" },
          },
          require("null_ls").builtins.diagnostics.clazy.with {
            ft = { "cpp" },
            cmd = { "clazy-standalone" },
            extra_args = { "--ignore-included-files", "--header-filter=$ROOT/.*", "$FILENAME" },
          },

          --CMake--

          --cmake_format | Parse cmake listfiles and format them nicely
          require("null_ls").builtins.formatting.cmake_format.with {
            ft = { "cmake" },
            cmd = { "cmake-format" },
            extra_args = { "-" },
          },

          --cmake_lint | Check cmake listfiles for style violations, common mistakes, and anti-patterns.
          require("null_ls").builtins.diagnostics.cmake_lint.with {
            ft = { "cmake" },
            cmd = { "cmake-lint" },
            extra_args = { "$FILENAME" },
          },
          --gersemi | A formatter to make your CMake code the real treasure
          require("null_ls").builtins.formatting.gersemi.with {
            ft = { "cmake" },
            cmd = { "gersemi" },
            extra_args = { "-" },
          },

          --C#--

          --csharpier | CSharpier is an opinionated code formatter for c#
          require("null_ls").builtins.formatting.csharpier.with {
            ft = { "cs" },
            cmd = { "dotnet-sharpier" },
            extra_args = { "write-stdout" },
          },

          --D2--

          --d2_fmt | d2 fmt is a tool built into the d2 compiler for formatting d2 diagram source
          null_ls.builtins.formatting.d2_fmt.with {
            ft = { "d2" },
            cmd = { "d2" },
            extra_args = { "fmt", "-" },
          },

          --Dart--

          --dart_format | Replace the whitespace in your program with formatting that follows Dart guidelines.
          null_ls.builtins.formatting.dart_format.with {
            ft = { "dart" },
            cmd = { "dart" },
            extra_args = { "format" },
          },

          --Elixir--
          --credo | Static analysis of elixir files for enforcing code consistency.
          require("null_ls").builtins.diagnostics.credo.with {
            ft = { "elixir" },
            cmd = { "mix" },
            extra_args = { "credo", "suggest", "--format", "json", "--read-from-stdin", "$FILENAME" },
          },

          --Elm--

          --elm_format--
          --formats Elm source code according to a standard set of rules based on the official Elm Style Guide.
          null_ls.builtins.formatting.elm_format.with {
            ft = { "elm" },
            cmd = { "elm-format" },
            extra_args = { "--stdin" },
          },

          --Gleam--

          --gleam_format | Default formatter for the Gleam programming language
          null_ls.builtins.formatting.gleam_format.with {
            ft = { "cmake" },
            cmd = { "gleam" },
            extra_args = { "format", "--stdin" },
          },

          -- Grammar/spelling --

          --codespell | Fix common misspellings in text files.
          -- require("null_ls").builtins.diagnostics.codespell.with {
          --  ft = { "" },
          --  cmd = { "codespell" },
          --  extra_args = { "-" },
          -- },
          --crystal_format | A tool for automatically checking and correcting the style of code in a project.
          require("null_ls").builtins.formatting.crystal_format.with {
            ft = { "crystal" },
            cmd = { "crystal" },
            extra_args = { "tool", "format", "-" },
          },
          --dictionary |Shows the first available definition for the current word under the cursor.
          require("null_ls").builtins.hover.dictionary.with {
            ft = { "org", "text", "markdown" },
          },
          --editorconfig_checker | A tool to verify that your files are in harmony with your .editorconfig.
          require("null_ls").builtins.diagnostics.editorconfig_checker.with {
            ft = { "" },
            cmd = { "editorconfig-checker" },
            extra_args = { "-no-color", "$FILENAME" },
          },
          --refactoring | The Refactoring library based off the Refactoring book by Martin Fowler.
          require("null_ls").builtins.code_actions.refactoring.with {
            ft = { "go", "javascript", "lua", "python", "typescript" },
            cmd = { "code_action" },
          },

          --proselint | An English prose linter. Can fix some issues via code actions.
          -- require("null_ls").builtins.code_actions.proselint.with {
          --  ft = { "markdown", "tex" },
          --  cmd = { "proselint" },
          --},
          --rstchek | Checks syntax of reStructuredText and code blocks nested within it.
          require("null_ls").builtins.diagnostics.rstcheck.with {
            ft = { "rst" },
            cmd = { "rstcheck" },
            extra_args = { "-r", "$DIRNAME" },
          },
          --semgrep--
          -- Semgrep is a fast, open-source, static analysis tool
          --for finding bugs and enforcing code standards at editor, commit, and CI time.
          require("null_ls").builtins.diagnostics.semgrep.with {
            ft = { "typescript", "typescriptreact", "ruby", "python", "java", "go" },
            cmd = { "semgrep" },
            extra_args = { "-q", "--json", "$FILENAME" },
          },
          --spell | Spell suggestions completion source.
          require("null_ls").builtins.completion.spell.with {
            ft = { "" },
          },
          --styleint | A mighty, modern linter that helps you avoid errors and enforce conventions in your styles.
          require("null_ls").builtins.diagnostics.stylelint.with {
            ft = { "scss", "less", "css", "sass" },
            cmd = { "stylelint" },
          },
          --tags | Tags completion source
          require("null_ls").builtins.completion.tags.with {
            ft = { "" },
          },
          --ts_node_action | A framework for running functions on Tree-sitter nodes and updating the buffer with the result.
          require("null_ls").builtins.code_actions.ts_node_action.with {
            ft = { "" },
          },
          --write-good | OBNOXIOUS for enterprise/production, but EXCELLENT for teaching programmers with persistent syntax errors or new coders.
          -- require("null-ls").builtins.diagnostics.write_good.with {
          --  ft = { "markdown" },
          --  cmd = { os.getenv "HOME" .. "/.nvm/versions/node/v22.9.0/bin/write-good" },
          --  extra_args = { "--no-passive", "--no-so" },
          -- },

          --Git--
          --commitlint |
          require("null_ls").builtins.diagnostics.commitlint.with {
            ft = { "gitcommit" },
            cmd = { "commitlint" },
            extra_args = { "--format", "commitlint-format-json" },
          },
          --Gitsigns | Injects code actions for Git operations at the current cursor position:
          --(stage
          --preview
          --reset hunks
          --blame,
          --etc.
          gitsigns = null_ls.builtins.code_actions.gitsigns.with {
            config = {
              filter_actions = function(title)
                return title:lower():match "blame" == nil
              end,
            },
          },
          --Gitrebase | Injects actions to change gitrebase command (e.g. using squash instead of pick).
          require("null_ls").builtins.code_actions.gitrebase.with {
            ft = { "gitrebase" },
          },

          -- Go--

          --asmfmt | Format your assembler code in a similar way that gofmt formats your go code.
          require("null_ls").builtins.formatting.asmfmt.with {
            ft = { "asm" },
            cmd = { "asmfmt" },
          },
          --goimports | Updates your Go import lines, adding missing ones and removing unreferenced ones.
          require("null_ls").builtins.formatting.goimports.with {
            ft = { "go" },
            cmd = { "goimports" },
            extra_args = { "-srcdir", "$DIRNAME" },
          },
          --goimportsreviser | Tool for Golang to sort goimports by 3 groups: std, general and project dependencies.
          require("null_ls").builtins.formatting.goimports_reviser.with {
            ft = { "go" },
            cmd = { "goimport-reviser" },
            extra_args = { "$FILENAME" },
          },

          --gofmt | Formats go programs.
          null_ls.builtins.formatting.gofmt.with {
            ft = { "go" },
            cmd = { "gofmt" },
          },
          --gofumpt | Enforce a stricter format than gofmt, while being backwards compatible.
          require("null_ls").builtins.formatting.gofumpt.with {
            ft = { "go" },
            cmd = { "gofumpt" },
          },
          --gomodifytags | Go tool to modify struct field tags
          require("null_ls").builtins.code_actions.gomodifytags,
          --golangcli_lint | A go linter aggregator
          require("null_ls").builtins.diagnostics.golangci_lint.with {
            ft = { "go" },
            cmd = { "golangcli-lint" },
            extra_args = { "run", "--fix=false", "--out-format=json" },
          },
          --golines | Applies a base formatter (eg. goimports or gofmt), then shortens long lines of code.
          require("null_ls").builtins.formatting.golines.with {
            ft = { "go" },
            cmd = { "golines" },
          },
          --revive | Fast, configurable, extensible, flexible, and beautiful linter for Go.
          require("null_ls").builtins.diagnostics.revive.with {
            ft = { "go" },
            cmd = { "revive" },
            extra_args = { "-formatter", "json", "./..." },
          },
          --staticcheck | Advanced Go linter.
          null_ls.builtins.diagnostics.staticcheck.with {
            ft = { "go" },
            cmd = { "staticcheck" },
            extra_args = { "-f", "json", "./..." },
          },
          --vacuum | The world's fastest and most scalable OpenAPI linter
          null_ls.builtins.diagnostics.vacuum.with {
            ft = { "yaml", "json" },
            cmd = { "vacuum" },
            extra_args = { "report", "--stdin", "--stdout" },
          },
          --verilator | Verilog and SystemVerilog linter power by verilator
          null_ls.builtins.diagnostics.verilator.with {
            ft = { "verilog", "systemverilog" },
            cmd = { "verilator" },
            extra_args = { "-lint-only", "-Wno-fatal", "$FILENAME" },
          },

          --Fortran--

          --findent | findent indents/beautifies/converts and can optionally generate the dependencies of Fortran sources.
          require("null_ls").builtins.formatting.findent.with {
            ft = { "fortran" },
            cmd = { "findent" },
            extra_args = { "" },
          },
          --fnlfmt | fnlfmt is a Fennel code formatter for established Lisp convention formatting given a piece of code.
          require("null_ls").builtins.formatting.fnlfmt.with {
            ft = { "fennel", "fnl" },
            cmd = { "fnlfmt" },
            extra_args = { "" },
          },
          -- fprettify | fprettify is a strict python auto-formatter imposing whitespace checks for modern Fortran code.
          require("null_ls").builtins.formatting.fprettify.with {
            ft = { "fortran" },
            cmd = { "fprettify" },
            extra_args = { "--silent" },
          },

          --Godot--

          --gdformat | A formatter for Godot's gdscript
          require("null_ls").builtins.formatting.gdformat.with {
            fmt = { "gd", "gdscript", "gdscript3" },
            cmd = { "gdformat" },
            extra_args = { "-" },
          },

          --Groovy--

          --npm_groovy_lint | Lint, format and auto-fix Groovy, Jenkinsfile, and Gradle files.
          null_ls.builtins.diagnostics.npm_groovy_lint.with {
            filetypes = { "groovy", "java", "Jenkinsfile" },
            command = { "npm_groovy_lint" },
            extra_args = { "-o", "json", "-" },
          },

          --HAML--

          --haml_lint | Tool for writing clean and consistent HAML.
          null_ls.builtins.diagnostics.haml_lint.with {
            ft = { "haml" },
            cmd = { "haml-lint" },
            extra_args = { "--reporter", "json", "$FILENAME" },
          },

          --Html--

          --djhtml | A pure-Python Django/Jinja template indenter without dependencies.
          require("null_ls").builtins.formatting.djhtml.with {
            ft = { "django", "jinja.html", "htmldjango" },
            cmd = { "djhtml" },
            extra_args = { "-" },
          },

          --djlint | ✨ 📜 🪄 ✨ HTML Template Linter and Formatter.
          require("null_ls").builtins.diagnostics.djlint.with {
            ft = { "django", "jinja.html", "htmldjango" },
            cmd = { "djlint" },
            extra_args = { { "--quiet", "-" } },
          },
          --Tidy corrects and cleans up HTML and XML documents by fixing markup errors and modernizing legacy code.
          require("null_ls").builtins.formatting.tidy.with {
            ft = { "html", "xml" },
            cmd = { "tidy" },
            extra_args = { "--tidy-mark", "no", "-quiet", "-indent", "-wrap", "-" },
          },

          --Laravel--
          require("null_ls").builtins.formatting.blade_formatter.with {
            ft = { "blade" },
            cmd = { "blade-formatter" },
            extra_args = { "--write", "$FILENAME" },
          },
          --blade_formatter | An opinionated blade template formatter for Laravel that respects readability

          --Lua--

          --luasnip | Snippet engine for Neovim, written in Lua.
          require("null_ls").builtins.completion.luasnip.with {
            ft = { "" },
          },
          require "none-ls-luacheck.diagnostics.luacheck",

          --selene | Command line tool designed to help write correct and idiomatic Lua code.
          require("null_ls").builtins.diagnostics.selene.with {
            ft = { "lua", "luau" },
            cmd = { "selene" },
            extra_args = { "--display-style", "quiet", "-" },
          },
          --stylua | An opinionated code formatter for Lua.
          require("null_ls").builtins.formatting.stylua.with {
            filetypes = { "lua", "luau" },
            command = { "stylua" },
            extra_args = { "--config-path", vim.fn.expand "$HOME" .. "/.config/nvim/.stylua.toml" },
          },

          --teal | The compiler for Teal, a typed dialect of Lua.
          null_ls.builtins.diagnostics.teal.with {
            ft = { "teal" },
            cmd = { "tl" },
            extra_args = { "check", "$FILENAME" },
          },
          --todo_comments | Uses inbuilt Lua code and treesitter to detect lines with TODO comments warning by line.
          require("null_ls").builtins.diagnostics.todo_comments.with {},
          --trail_space | Uses inbuilt Lua code to detect lines with trailing whitespace with a diagnostic warning by line.
          require("null_ls").builtins.diagnostics.trail_space.with {},

          --Java--

          require("null_ls").builtins.diagnostics.checkstyle.with {
            ft = { "java" },
            cmd = { "checkstyle" },
            extra_args = { "-f", "sarif", "-c", "$ROOT", "/google_checks.xml" },
          },

          --google_java_format | Reformats Java source code according to Google Java Style.
          null_ls.builtins.formatting.google_java_format.with {
            ft = { "java" },
            cmd = { "google-java-format" },
          },

          --Javascript--

          --Prettierd | prettier, as a daemon, for ludicrous formatting speed.
          require("null_ls").builtins.formatting.prettierd.with {
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "css",
              "scss",
              "less",
              "html",
              "json",
              "jsonc",
              "yaml",
              "markdown",
              "markdown.mdx",
              "graphql",
              "handlebars",
              "svelte",
              "astro",
              "htmlangular",
            },
            cmd = { "prettierd" },
          },

          require "none-ls.diagnostics.eslint",
          require "none-ls-ecs.formatting",
          --biome | Formatter, linter, bundler, and more for JavaScript, TypeScript, JSON, HTML, Markdown, and CSS.
          null_ls.builtins.formatting.biome.with {
            ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
            cmd = { "biome" },
            extra_args = { "format", "--stdin-file-path", "$FILENAME" },
          },

          --Make--

          --checkmake | make linter.
          require("null_ls").builtins.diagnostics.checkmake.with {
            ft = { "make" },
            cmd = { "checkmake" },
            extra_args = { "--format='{{.LineNumber}}:{{.Rule}}:{{.Violation}}\n'", "$FILENAME" },
          },

          --Markdown--

          --cbfmt | A tool to format codeblocks inside markdown and org documents
          require("null_ls").builtins.formatting.cbfmt.with {
            ft = { "markdown", "org" },
            cmd = { "cbfmt" },
            extra_args = { "--stdin-filepath", "$FILENAME", "--best-effort" },
          },
          --markdownlint | Markdown style and syntax checker
          require("null_ls").builtins.formatting.markdownlint.with {
            ft = { "markdown" },
            cmd = { "markdownlint" },
          },
          --markdownlint_cli2 | A fast, flexible, configuration-based cli tool for linting via markdownlint library.
          require("null_ls").builtins.diagnostics.markdownlint_cli2.with {
            ft = { "markdown" },
            cmd = { "markdownlint-cli2" },
          },
          --spell | Spell suggestions completion source.
          require("null_ls").builtins.completion.spell.with {
            ft = { "" },
          },
          --markuplint | --A linter for all markup developers.
          require("null_ls").builtins.diagnostics.markuplint.with {
            ft = { "html" },
            cmd = { "markuplint" },
            extra_args = { "--format", "JSON", "$FILENAME" },
          },
          --mdl | A tool to check Markdown files and flag style issues.
          require("null_ls").builtins.diagnostics.mdl.with {
            ft = { "markdown" },
            cmd = { "mdl" },
            extra_args = { "--json" },
          },
          --mdformat | An opinionated Markdown formatter that can be used to enforce a consistent style in Markdown files
          require("null_ls").builtins.formatting.mdformat.with {
            ft = { "markdown" },
            cmd = { "mdformat" },
            extra_args = { "$FILENAME" },
          },
          --textlint | The pluggable linting tool for text and Markdown.
          require("null_ls").builtins.formatting.textlint.with {
            ft = { "txt", "markdown" },
            cmd = { "textlint" },
            extra_args = { "-f", "json", "--stdin", "--stdin-filename", "$FILENAME" },
          },
          --vale | Syntax-aware linter for prose built with speed and extensibility in mind.
          -- require("null_ls").builtins.diagnostics.vale.with {
          --  ft = { "markdown", "tex", "asciidoc" },
          --  command = { "vale" },
          -- },

          --LaTeX--

          --textidote | Spelling, grammar and style checking on LaTeX documents.
          require("null_ls").builtins.diagnostics.textidote.with {
            ft = { "markdown", "text" },
            cmd = { "textidote" },
            extra_args = {
              "--read-all",
              "--output",
              "singleline",
              "--no-color",
              "--check",
              "en",
              "--quiet",
              "$FILENAME",
            },
          },

          --MATLAB--
          require("null_ls").builtins.diagnostics.mlint.with {
            ft = { "matlab", "octave" },
            cmd = { "mlint" },
            extra_args = { "$FILENAME" },
          },

          --Nix--

          --deadnix | Scan Nix files for dead code.
          null_ls.builtins.diagnostics.deadnix.with {
            ft = { "nix" },
            cmd = { "deadnix" },
          },

          --statix | Lints and suggestions for the nix programming language.
          null_ls.builtins.code_actions.statix.with {
            ft = { "nix" },
            cmd = { "statix" },
            extra_args = { "check", "--stdin", "--format=json" },
          },

          --Perl--
          --perlimports | A command line utility for cleaning up imports in your Perl code
          require("null_ls").builtins.diagnostics.perlimports.with {
            ft = { "perl" },
            cmd = { "perlimports" },
            extra_args = { "--lint", "--read-stdin", "--filename", "$FILENAME" },
          },

          --PHP--

          require "none-ls-php.diagnostics.php",
          require "none-ls-psalm.diagnostics",
          --phpstan | PHP static analysis tool.
          require("null_ls").builtins.diagnostics.phpstan.with {
            ft = { "php" },
            cmd = { "phpstan" },
            extra_args = { "analyze", "--error-format", "json", "--no-progress", "$FILENAME" },
          },
          --PHP_CodeSniffer is a script that tokenizes violations of a defined coding standard for:
          --PHP
          --JavaScript
          --and CSS files
          require("null_ls").builtins.diagnostics.phpcs.with {
            ft = { "php" },
            cmd = { "phpcs" },
            extra_args = {
              "--report=json",
              "-q",
              "-s",
              "--runtime-set",
              "ignore_warnings_on_exit",
              "1",
              "--runtime-set",
              "ignore_errors_on_exit",
              "1",
              "--stdin-path=$FILENAME",
              "--basepath=",
            },
          },
          --phpmd | Runs PHP Mess Detector against PHP files
          require("null_ls").builtins.diagnostics.phpmd.with {
            ft = { "php" },
            cmd = { "phpmd" },
            extra_args = { "$FILENAME", "json" },
          },

          --PostgreSQL--

          --pg_format | PostgreSQL SQL syntax beautifier
          require("null_ls").builtins.formatting.pg_format.with {
            ft = { "sql", "pgsql" },
            cmd = { "pq_format" },
          },

          --Puppet--

          --puppet_lint | Check that your Puppet manifest conforms to the style guide.
          null_ls.builtins.diagnostics.puppet_lint.with {
            ft = { "puppet", "epuppet" },
            cmd = { "puppet-lint" },
            extra_args = { "--json", "$FILENAME" },
          },
          --Python--

          --black | The uncompromising Python code formatter
          require("null_ls").builtins.formatting.black.with {
            ft = { "python" },
            cmd = { "black" },
          },
          --blackd | blackd is a small HTTP server that exposes Black’s functionality over a simple protocol.
          --Blackd's main benefit is cost avoidance with loading a Black process every time you want to blacken a file.
          --The only way to configure the formatter is by using the provided config options.
          --it will NOT pick up on config files.
          require("null_ls").builtins.formatting.blackd.with {
            ft = { "python" },
          },
          --isort | Python utility / library automatically sorting imports alphabetically and by sections type.
          require("null_ls").builtins.formatting.isort.with {
            ft = { "python" },
            cmd = { "isort" },
            extra_args = { "--stdout", "--filename", "$FILENAME", "-" },
          },
          --mypy | An optional static type checker for Python that aims to combine dynamic/"duck" and static typing.
          require("null_ls").builtins.diagnostics.mypy.with {
            ft = { "python" },
            cmd = { "mypy" },
          },
          --pyink | The Google Python code formatter
          null_ls.builtins.formatting.pyink.with {
            ft = { "python" },
            cmd = { "pyink" },
          },
          --pylint | is a Python static code analysis tool featuring
          --looking for programming errors
          --helps enforcing a coding standard
          --sniffs for code smells
          --offers simple refactoring suggestions.
          require("null_ls").builtins.diagnostics.pylint.with {
            ft = { "python" },
            cmd = { "pylint" },
          },

          --yapf | Formatter for Python
          require("null_ls").builtins.formatting.yapf.with {
            ft = { "python" },
            cmd = { "yapf" },
          },

          --R--

          require("null_ls").builtins.formatting.forge_fmt.with {
            ft = { "r", "rmd" },
            cmd = { "R" },
          },

          --Ruby--

          --erb_format | Format ERB files with speed and precision.
          require("null_ls").builtins.formatting.erb_format.with {
            ft = { "eruby" },
            cmd = { "erb-format" },
            extra_args = { "--stdin" },
          },

          --erb_lint | Lint your ERB or HTML files
          ft = { "eruby" },
          cmd = { "erblint" },
          extra_args = { "--format", "json", "--stdin", "$FILENAME" },
          --reek | Code smell detector for Ruby
          null_ls.builtins.diagnostics.reek.with {
            ft = { "ruby" },
            cmd = { "reek" },
            extra_args = { "--format", "json", "--stdin-filename", "$FILENAME" },
          },
          --rpmspec | Command line tool to parse RPM spec files.
          require("null_ls").builtins.diagnostics.rpmspec.with {
            ft = { "spec" },
            cmd = { "rpmspec" },
            extra_args = { "-r", "$DIRNAME" },
          },
          --rubyfmt | Format your ruby code!
          null_ls.builtins.formatting.rubyfmt.with {
            ft = { "ruby" },
            cmd = { "rubyfmt" },
          },
          --rubocop | The Ruby Linter/Formatter that Serves and Protects.
          require("null_ls").builtins.diagnostics.rubocop.with {
            ft = { "ruby" },
            cmd = { "rubocop" },
            extra_args = { "-f", "json", "--force-exclusion", "--stdin", "$FILENAME" },
          },
          null_ls.builtins.formatting.rubocop,
          --Regal is a linter for Rego, with the goal of making your Rego magnificent!.
          require("null_ls").builtins.diagnostics.regal.with {
            ft = { "rego" },
            cmd = { "regal" },
          },

          --Rust--

          --dxfmt | Format rust files with dioxus cli
          require("null_ls").builtins.formatting.dxfmt.with {
            ft = { "rust" },
            cmd = { "dx" },
            extra_args = { "fmt", "--file", "$FILENAME" },
          },

          --LanguageTool-Rust (LTRS) is an executable/library providing correct and safe bindings for LanguageTool.
          require("null_ls").builtins.diagnostics.ltrs.with {
            ft = { "text", "markdown", "markdown" },
            cmd = { "ltrs" },
          },

          --Salt--

          --saltlint | A command-line utility that checks for best practices in SaltStack.
          require("null_ls").builtins.diagnostics.saltlint.with {
            ft = { "sls" },
            cmd = { "salt_lint" },
            extra_args = { "--nocolor", "--json", "$FILENAME" },
          },

          --Solidity--
          null_ls.builtins.formatting.forge_fmt.with {
            ft = { "solidity" },
            cmd = { "forge" },
            extra_args = { "fmt", "$FILENAME" },
          },

          --Shell--
          -- shellcheck | A popular shell script static analysis tool that finds syntax errors, bad practices, and potential bugs.
          require("null_ls").builtins.diagnostics.shellcheck.with {
            filetypes = { "sh", "bash", "zsh" },
            command = "shellcheck",
            extra_args = { "--severity=style" },
          },
          -- shellcheck (code actions) | Suggests automatic fixes to shell script issues detected by shellcheck.
          require("null_ls").builtins.code_actions.shellcheck.with {
            filetypes = { "sh", "bash", "zsh", "rc" },
            command = "shellcheck",
          },
          --shfmt | A shell parser, formatter, and interpreter with bash support.
          require("null_ls").builtins.formatting.shfmt.with {
            filetypes = { "sh", "bash", "zsh", "rc" },
            command = { "shfmt" },
            extra_args = { "-i", "2", "-ci", "-sr", "-bn", "-fn", "-kp", "--shellopts", "braces" },
          },
          --shellharden | Hardens shell scripts by quoting variables, replacing function_call with $(function_call)
          require("null_ls").builtins.formatting.shellharden.with {
            filetypes = { "sh", "bash", "zsh", "rc" },
            command = "shellharden",
            extra_args = { "--replace" },
          },
          on_attach = function(client, bufnr)
            if client.resolved_capabilities.document_formatting then
              vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                vim.lsp.buf.format { async = false }
              end, { desc = "Format current buffer with LSP" })

              vim.cmd [[
                augroup LspFormatting
                    autocmd! * <buffer>
                    autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })
                augroup END
            ]]
            end
          end,

          --SPIR--

          --glslc | Shader to SPIR-V compiler.
          require("null_ls").builtins.diagnostics.glslc.with {
            ft = { "glsl" },
            cmd = { "glslc" },
            extra_args = function(params)
              local stage = "vertex"
              if params.bufname:match "%.vert%.glsl" then
                stage = "vertex"
              elseif params.bufname:match "%.frag%.glsl" then
                stage = "fragment"
              elseif params.bufname:match "%.comp%.glsl" then
                stage = "compute"
              end
              return { "-fshader-stage=" .. stage, "--target-env=opengl" }
            end,
          },

          --SQL--

          --sqlfluff | A SQL linter and auto-formatter for Humans
          require("null_ls").builtins.diagnostics.sqlfluff.with {
            ft = { "sql" },
            cmd = { "sqlfluff" },
            extra_args = {
              "--dialect",
              "postgres",
              "lint",
              "--disable-progress-bar",
              "-f",
              "github-annotation",
              "-n",
              "$FILENAME",
            },
          },
          --sqlfmt | Formats your dbt SQL files so you don't have too
          require("null_ls").builtins.formatting.sqlfmt.with {
            ft = { "sql", "jinja" },
            cmd = { "sqlfmt" },
            extra_args = { "-" },
          },
          --Notes: SQLFluff needs a mandatory --dialect argument. Use extra_args to add yours,
          --or create a .sqlfluff file in the same directory as the SQL file to specify the dialect.

          --Swift--

          --swiftlint | A tool to enforce Swift style and conventions.
          require("null_ls").builtins.diagnostics.swiftlint.with {
            ft = { "swift" },
            cmd = { "swiftlint" },
            extra_args = { "{--reporter", "json", "--use-stdin", "--quiet" },
          },

          --Terraform--

          --terraform_validate | terraform_validate is a configuration validating subcommand for directory files
          require("null_ls").builtins.diagnostics.terraform_validate.with {
            ft = { "terraform", "tf", "terraform-vars" },
            cmd = { "terraform" },
            extra_args = { "validate", "-json" },
          },
          --terragrunt | Terragrunt validate is a subcommand of terragrunt to validate configuration files in a directory
          require("null_ls").builtins.diagnostics.terragrunt_validate.with {
            ft = { "hcl" },
            cmd = { "terragrunt" },
            extra_args = { "hclvalidate", "--terragrunt-hclvalidate-json" },
          },
          --tfsec | Security scanner for Terraform code
          require("null_ls").builtins.diagnostics.tfsec.with {
            ft = { "terraform", "tf", "terraform-vars" },
            cmd = { "tfsec" },
            extra_args = { "-s", "-f", "json", "$DIRNAME" },
          },
          --trivy | Find misconfigurations and vulnerabilities
          require("null_ls").builtins.diagnostics.trivy.with {
            ft = { "terraform", "tf", "terraform-vars" },
            cmd = { "trivy" },
          },

          --Twig--

          --twigcs | Runs Twigcs against Twig files.
          require("null_ls").builtins.diagnostics.twigcs.with {
            ft = { "twig" },
            cmd = { "twigcs" },
            extra_args = { "--reporter", "json", "$FILENAME" },
          },

          --Vim--

          --vint | Linter for Vimscript
          require("null_ls").builtins.diagnostics.vint.with {
            ft = { "vim" },
            cmd = { "vint" },
            extra_args = { "--style-problem", "--json", "$FILENAME" },
          },

          --vsnip | Snippets managed by vim-vsnip
          require("null_ls").builtins.completion.vsnip.with {
            ft = { "" },
          },

          --| Yet Another Markup Language (yaml)--

          --yamlfmt | is an extensible command line tool or library to format yaml files.
          require("null_ls").builtins.formatting.yamlfmt.with {
            ft = { "yaml" },
            cmd = { "yamlft" },
            extra_args = { "-" },
          },

          --yamllint | A Linter for YAML Files
          require("null_ls").builtins.diagnostics.yamllint.with {
            ft = { "yaml", "markdown" },
            cmd = { "yamllint" },
            extra_args = { "--format", "parsable", "-" },
          },

          --Zsh--

          --zsh | Uses zsh's own -n option to evaluate, but not execute, zsh scripts.
          require("null_ls").builtins.diagnostics.zsh.with {
            ft = { "zsh" },
            cmd = { "zsh" },
            extra_args = { "-n", "$FILENAME" },
          },
        },
      }

      -- lsp setup
      local lsp_defaults = {
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = function(client, bufnr)
          if client.supports_method "textdocument/formatting" then
            vim.api.nvim_buf_create_user_command(bufnr, "format", function()
              vim.lsp.buf.format { bufnr = bufnr }
            end, { desc = "format current buffer with lsp" })
          end
          print(client.name .. " attached to buffer " .. bufnr)
        end,
      }

      lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

      mason_lspconfig.setup_handlers {
        function(server_name)
          local config = lsp_defaults

          if server_name == "pyright" then
            config = vim.tbl_deep_extend("force", config, {
              settings = {
                python = {
                  analysis = {
                    extrapaths = {
                      "/usr/share/jupyter/kernels/python3",
                      vim.fn.expand "$home" .. "/.local/share/jupyter/kernels/mojo-jupyter-kernel",
                    },
                    typecheckingmode = "basic",
                    autosearchpaths = true,
                    uselibrarycodefortypes = true,
                  },
                },
              },
              filetypes = { "python", "jupyter", "ipynb" },
            })
          elseif server_name == "efm" then
            config = vim.tbl_deep_extend("force", config, {
              init_options = { documentformatting = true },
              filetypes = { "mojo" },
              settings = {
                rootmarkers = { ".git/" },
                languages = {
                  mojo = {
                    { formatcommand = "mojo format -", formatstdin = true },
                  },
                },
              },
            })
          end

          lspconfig[server_name].setup(config)
        end,
        ["rust_analyzer"] = function()
          require("rustaceanvim").setup {}
        end,
      }

      vim.g.jupytext_fmt = "py"
      vim.g.jupytext_style = "hydrogen"

      require("dap-go").setup()

      -- python
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "launch file",
          program = "${file}",
          pythonpath = function()
            return "/usr/bin/python"
          end,
        },
      }

      -- rust
      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb",
        name = "lldb",
      }
      dap.configurations.rust = {
        {
          name = "launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspacefolder}",
          stoponentry = false,
          args = {},
        },
      }
      require("rustaceanvim").setup()
      require("telescope").load_extension "zoxide"
    end,
    requires = {
      "nvim-lua/plenary.nvim",
      config = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.sh", "*.bash", "*.zsh" },
          callback = function()
            vim.lsp.buf.format()
          end,
        })
      end,
    },
  },
}
