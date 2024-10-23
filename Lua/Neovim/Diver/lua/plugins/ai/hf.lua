return {
  {
    "huggingface/llm.nvim",
    lazy = true,
    opts = {
      api_token = function()
        return vim.fn.system("pass show hf"):gsub("\n", "")
      end,
      model = "qompass/r3",
      backend = "huggingface",
      url = "https://localhost:3000",
      tokens_to_clear = { "<|endoftext|>" },
      request_body = {
        parameters = {
          max_new_tokens = 60,
          temperature = 0.2,
          top_p = 0.95,
          frequency_penalty = 0.5,
          presence_penalty = 0.6,
        },
      },
      fim = {
        enabled = true,
        prefix = "<fim_prefix>",
        middle = "<fim_middle>",
        suffix = "<fim_suffix>",
      },
      debounce_ms = 150,
      accept_keymap = "<Tab>",
      dismiss_keymap = "<S-Tab>",
      tls_skip_verify_insecure = false,
      lsp = {
        bin_path = nil,
        host = nil,
        port = nil,
        cmd_env = nil,
        version = "0.5.3",
      },
      tokenizer = "qompass/r3",
      context_window = 1024,
      enable_suggestions_on_startup = true,
      enable_suggestions_on_files = "*",
      disable_url_path_completion = false,
    },
    config = function(_, opts)
      require("llm").setup(opts)
    end,
  },
}
