return {
    "mfussenegger/nvim-dap",
    lazy = false,
    ft = { "python", "py", "go", "rust", "java", "cpp", "c", "lua", "javascript", "typescript", "sh", "bash", "zsh", "rc", "jupyter", "ipynb" },
    config = function()
        local dap = require('dap')

        -- Python Debug Adapter (Debugpy)
        dap.adapters.python = {
            type = 'executable',
            command = 'python',
            args = { '-m', 'debugpy.adapter' },
        }
        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                    return '/usr/bin/python'
                end,
            },
        }
        -- Bash Debug Adapter using bashdb
        dap.adapters.bash = {
            type = 'executable',
            command = '/usr/bin/bashdb',
            args = {},
        }
        dap.configurations.sh = {
            {
                type = 'bash',
                request = 'launch',
                name = "Launch Bash script",
                program = "${file}",
                cwd = '${workspaceFolder}',
                pathBashdb = '/usr/bin/bashdb',
                pathBash = '/bin/bash',
                args = {},
                env = {},
                terminalKind = "integrated",
            },
        }

        -- Go Debug Adapter (Delve)
        dap.adapters.go = {
            type = 'server',
            port = 38697,
            executable = {
                command = 'dlv',
                args = { 'dap', '-l', '127.0.0.1:38697' },
            },
        }
        dap.configurations.go = {
            {
                type = 'go',
                name = 'Debug',
                request = 'launch',
                program = "${file}",
            },
        }

        -- Rust Debug Adapter (LLDB)
        dap.adapters.lldb = {
            type = 'executable',
            command = '/usr/bin/lldb',
            name = "lldb",
        }
        dap.configurations.rust = {
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
            },
        }
        -- Java Debug Adapter (Java Debug Server)
        dap.adapters.java = {
            type = 'server',
            host = '127.0.0.1',
            port = 5005,
        }
        dap.configurations.java = {
            {
                type = 'java',
                request = 'attach',
                name = "Attach to the process",
                hostName = "127.0.0.1",
                port = 5005,
            },
        }
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = true,
                setupCommands = {
                    {
                        text = '-enable-pretty-printing',
                        description = 'enable pretty printing',
                        ignoreFailures = false,
                    },
                },
            },
        }
        dap.configurations.c = dap.configurations.cpp

        dap.adapters.node2 = {
            type = 'executable',
            command = 'node',
            args = { os.getenv('HOME') .. '/vscode-node-debug2/out/src/nodeDebug.js' },
        }
        dap.configurations.javascript = {
            {
                name = "Launch file",
                type = "node2",
                request = "launch",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
            },
        }
        dap.configurations.typescript = dap.configurations.javascript
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end,
}

