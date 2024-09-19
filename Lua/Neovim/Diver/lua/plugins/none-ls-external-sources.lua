return {
  "zeioth/none-ls-autoload.nvim",
  event = "BufEnter",
  dependencies = {
    "williamboman/mason.nvim",
    "zeioth/none-ls-external-sources.nvim"
  },
  opts = {
     external_sources = {
      -- Diagnostics
      'none-ls-external-sources.diagnostics.cpplint',      -- C/C++ linter
      'none-ls-external-sources.diagnostics.eslint',       -- JavaScript/TypeScript linter
      'none-ls-external-sources.diagnostics.eslint_d',     -- Faster JavaScript/TypeScript linter (daemon)
      'none-ls-external-sources.diagnostics.flake8',       -- Python linter
      'none-ls-external-sources.diagnostics.luacheck',     -- Lua linter
      'none-ls-external-sources.diagnostics.psalm',        -- PHP static analysis tool
      'none-ls-external-sources.diagnostics.shellcheck',   -- Shell script linter
      'none-ls-external-sources.diagnostics.yamllint',     -- YAML linter

      -- Formatting
      'none-ls-external-sources.formatting.autopep8',      -- Python code formatter
      'none-ls-external-sources.formatting.beautysh',      -- Shell script beautifier
      'none-ls-external-sources.formatting.easy-coding-standard', -- PHP coding standard fixer
      'none-ls-external-sources.formatting.eslint',        -- JavaScript/TypeScript formatter
      'none-ls-external-sources.formatting.eslint_d',      -- Faster JavaScript/TypeScript formatter (daemon)
      'none-ls-external-sources.formatting.jq',            -- JSON processor and formatter
      'none-ls-external-sources.formatting.latexindent',   -- LaTeX formatter
      'none-ls-external-sources.formatting.reformat_gherkin', -- Gherkin (Cucumber) formatter
      'none-ls-external-sources.formatting.rustfmt',       -- Rust code formatter
      'none-ls-external-sources.formatting.standardrb',    -- Ruby code formatter
      'none-ls-external-sources.formatting.yq',            -- YAML processor and formatter

      -- Code Actions
      'none-ls-external-sources.code_actions.eslint',      -- JavaScript/TypeScript code actions
      'none-ls-external-sources.code_actions.eslint_d',    -- Faster JavaScript/TypeScript code actions (daemon)
      'none-ls-external-sources.code_actions.shellcheck',  -- Shell script code actions
    },
  },
}

