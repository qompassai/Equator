local autocmd = vim.api.nvim_create_autocmd

-- Signature Help Autocmd
autocmd("TextChangedI", {
  callback = function()
    vim.schedule(function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients > 0 then
        local client = clients[1]
        if client.server_capabilities.signatureHelpProvider then
          vim.lsp.buf.signature_help()
        end
      end
    end)
  end,
})

-- Save on Formatting Autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rc",
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})

-- FilePost Autocmd
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name("NvFilePost")

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          pcall(require, "editorconfig")
          if package.loaded["editorconfig"] then
            require("editorconfig").config(args.buf)
          end
        end
      end)
    end
  end,
})

