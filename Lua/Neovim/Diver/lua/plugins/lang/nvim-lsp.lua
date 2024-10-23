return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "leoluz/nvim-dap-go",
    "mrcjkb/rustaceanvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local mason_lspconfig = require "mason-lspconfig"
    require("mason").setup()

    require("mason-lspconfig").setup {
      ensure_installed = { "lua_ls", "pyright" },
    }

    require("nvim-web-devicons").setup {
      default = true,
    }
    local dap = require "dap"

    local lspconfig = require "lspconfig"
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local lsp_defaults = {
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        if client.supports_method "textDocument/formatting" then
          vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
            vim.lsp.buf.format { bufnr = bufnr }
          end, { desc = "Format current buffer with LSP" })
        end
        print(client.name .. " attached to buffer " .. bufnr)
      end,
    }

    lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

    -- Diagnostic settings
    vim.diagnostic.config {
      virtual_text = true,
      signs = false,
      underline = true,
      update_in_insert = true,
      severity_sort = true,
    }

    local function get_lsp_cmd(package_name, executable_name)
      if vim.fn.executable(executable_name) == 1 then
        return executable_name
      end
      local mason_path = vim.fn.stdpath "data" .. "/mason/packages/" .. package_name .. "/bin/" .. executable_name
      if vim.fn.filereadable(mason_path) == 1 then
        return mason_path
      else
        vim.notify("LSP executable not found: " .. executable_name, vim.log.levels.ERROR)
        return nil
      end
    end
    -- C/C++
    lspconfig.clangd.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("clangd", "clangd") },
    }
    -- Containers (Docker/Podman/OCI)
    lspconfig.dockerls.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("docker-langserver", "docker-langserver") },
      on_attach = function(client, bufnr)
        if client.supports_method "textDocument/formatting" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
    lspconfig.docker_compose_language_service.setup {
      capabilities = capabilities,
      cmd = { vim.fn.stdpath "data" .. "/mason/packages/docker-compose-language-service/bin/docker-compose-language-service" },
      filetypes = { "Dockerfile", "yaml", "yml", "Containerfile" },
      settings = {
        docker = {
          linting = {
            enabled = true,
          },
        },
      },
    }
    -- Deno
    lspconfig.denols.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("deno", "deno") },
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
      init_options = {
        enable = true,
        lint = true,
        unstable = true,
      },
      settings = {
        deno = {
          enable = true,
          lint = true,
          unstable = true,
        },
      },
      filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
      },
    }
    --Diagnosticls
    local enable_diagnosticls = true

    if enable_diagnosticls then
      require("lspconfig").diagnosticls.setup {
        autostart = false,
        filetypes = { "lua", "javascript", "typescript", "python" },
        init_options = {
          filetypes = {
            lua = "lua-format",
          },
          formatters = {
            ["lua-format"] = {
              command = "lua-format",
              args = {
                "--indent-width=4",
                "--column-limit=130",
              },
            },
          },
          formatFiletypes = {
            lua = "lua-format",
          },
        },
      }
    end

    -- Go
    lspconfig.gopls.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("gopls", "gopls") },
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    }
    -- Java
    lspconfig.jdtls.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("jdtls", "jdtls") },
    }
    -- JSON
    lspconfig.jsonls.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("vscode-json-languageserver", "vscode-json-languageserver") },
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
          end,
        },
      },
    }
    -- Lua
    require("lspconfig").lua_ls.setup {
      cmd = { get_lsp_cmd("lua-language-server", "lua-language-server"), "-E" },
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = (vim.fn.executable "luajit" == 1) and "LuaJIT" or "Lua 5.1",
            path = vim.split(package.path, ";"),
          },
          diagnostics = {
            globals = {
              "vim",
              "use",
              "require",
              "pcall",
              "pairs",
              "ipairs",
              "error",
              "assert",
              "print",
              "table",
              "string",
              "math",
              "os",
              "on_attach",
              "io",
              "debug",
              "package",
              "coroutine",
              "bit32",
              "utf8",
            },
            disable = { "missing-parameter", "lowercase-global", "mixed-type" },
          },
          severity = {
            ["missing-parameter"] = "Warning",
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            maxPreload = 10000,
            preloadFileSize = 150,
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
    -- Markdown
    lspconfig.marksman.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("marksman", "marksman") },
      filetypes = { "markdown", "markdown.mdx" },
      root_dir = lspconfig.util.root_pattern(".git", ".marksman.toml"),
    }
    -- Markdown Oxide
    lspconfig.markdown_oxide.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("markdown-oxide", "markdown-oxide") },
      filetypes = { "markdown" },
      root_dir = lspconfig.util.root_pattern ".git",
      single_file_support = true,
    }
    -- MDX Analyzer
    lspconfig.mdx_analyzer.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("mdx-language-server", "mdx-language-server"), "--stdio" },
      filetypes = { "markdown.mdx" },
      root_dir = lspconfig.util.root_pattern ".git",
      single_file_support = true,
    }
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.diagnostics.markdownlint.with {
          filetypes = { "markdown" },
        },
        null_ls.builtins.formatting.mdformat.with {
          filetypes = { "markdown" },
        },
        null_ls.builtins.diagnostics.markdownlint_cli2.with {
          filetypes = { "markdown" },
        },
        null_ls.builtins.diagnostics.markuplint.with {
          filetypes = { "markdown", "html" },
        },
      },
      on_attach = function(client, bufnr)
        if client.supports_method "textDocument/formatting" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
    -- MATLAB
    lspconfig.matlab_ls.setup { capabilities = capabilities }
    --Python (Azure-CLI, Jupyter Lab/Hub, Pyenv, Python, PyPy)
    mason_lspconfig.setup_handlers {
      function(server_name)
        local config = lsp_defaults

        if server_name == "pyright" then
          config = vim.tbl_deep_extend("force", config, {
            cmd = { get_lsp_cmd("pyright-langserver", "pyright-langserver"), "--stdio" },
            settings = {
              python = {
                analysis = {
                  extraPaths = {
                    "/usr/bin/python",
                    "/opt/pypy3/bin/python",
                    "/opt/azure-cli/bin/python",
                    "${HOME}/.pyenv/shims/python",
                    "/usr/share/jupyter/kernels/python3",
                    "/usr/bin/jupyter",
                    "/usr/bin/jupyter-lab",
                    "${HOME}/.local/bin/jupyterhub",
                  },
                  typeCheckingMode = "basic",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                  exclude = {
                    vim.fn.expand "${HOME}/.pythonrc",
                  },
                },
              },
            },
            filetypes = { "python", "jupyter", "ipynb", "mojo" },
            on_attach = function(client, bufnr)
              if client.name == "pyright" then
                vim.diagnostic.config {
                  virtual_text = true,
                  signs = true,
                  underline = true,
                  update_in_insert = true,
                }
              end
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format { async = true }
                end,
              })
            end,
          })
        elseif server_name == "pylsp" then
          config = vim.tbl_deep_extend("force", config, {
            cmd = { get_lsp_cmd("pylsp", "pylsp") },
            settings = {
              pylsp = {
                plugins = {
                  pyflakes = { enabled = false },
                  pylint = { enabled = true, executable = "pylint" },
                  flake8 = { enabled = false },
                  yapf = { enabled = false },
                  autopep8 = { enabled = false },
                  black = { enabled = true },
                  isort = { enabled = false },
                  mypy = { enabled = false, live_mode = false },
                },
              },
            },
            on_attach = function(client, bufnr)
              local filename = vim.api.nvim_buf_get_name(bufnr)
              if string.match(filename, "%.pythonrc$") then
                client.stop()
              end
              if client.name == "pyright" or client.name == "pylsp" then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format { async = true }
                  end,
                })
              end
            end,
          })
        elseif server_name == "efm" then
          config = vim.tbl_deep_extend("force", config, {
            cmd = { get_lsp_cmd("efm-langserver", "efm-langserver") },
            init_options = { documentFormatting = false },
            filetypes = { "mojo" },
            settings = {
              rootMarkers = { ".git/" },
              languages = {
                mojo = {
                  { formatCommand = "mojo format -", formatStdin = true },
                },
              },
            },
          })
        end
        -- Python Debug Adater Protocol (DAP)
        dap.adapters.python = {
          type = "executable",
          command = "python",
          args = { "-m", "debugpy.adapter" },
        }
        dap.configurations.python = {
          {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            pythonPath = function()
              return "/usr/bin/python"
            end,
          },
        }
        lspconfig[server_name].setup(config)
      end,
    }
    -- R
    lspconfig.r_language_server.setup { capabilities = capabilities }
    -- Ruby
    lspconfig.solargraph.setup { capabilities = capabilities }
    -- TypeScript
    lspconfig.ts_ls.setup {
      capabilities = capabilities,
      filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
      },
      root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", ".git"),
      on_attach = function(tsclient, ts_bufnr)
        tsclient.server_capabilities.documentFormattingProvider = false
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = ts_bufnr,
          callback = function()
            vim.cmd "Prettier"
          end,
        })
      end,
      settings = {
        javascript = {
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
            parameterTypes = {
              enabled = true,
            },
          },
        },
        typescript = {
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
            parameterTypes = {
              enabled = true,
            },
          },
        },
      },
    }
    -- TOML
    lspconfig.taplo.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("taplo", "taplo") },
      filetypes = { "toml" },
      on_attach = function(toml_client, toml_bufnr)
        if toml_client.supports_method "textDocument/formatting" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            buffer = toml_bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }

    -- YAML
    lspconfig.yamlls.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("yaml-language-server", "yaml-language-server") },
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
          },
        },
      },
      on_attach = function(yaml_client, yaml_bufnr)
        if yaml_client.supports_method "textDocument/formatting" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            buffer = yaml_bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
    -- ZLS (Zig Language Server)
    lspconfig.zls.setup {
      capabilities = capabilities,
      cmd = { get_lsp_cmd("zls", "zls") },
      filetypes = { "zig", "zir" },
      root_dir = lspconfig.util.root_pattern("zls.json", "build.zig", ".git"),
      single_file_support = true,
    }
  end,
}
