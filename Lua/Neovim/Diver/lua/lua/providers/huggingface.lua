--[[
-- Import necessary modules
local Utils = require("avante.utils")
local P = require("avante.providers")
local Clipboard = require("avante.clipboard")

---@class AvanteProviderFunctor
local M = {}

-- API key name for authentication
M.api_key_name = "HF_API_KEY"

-- Function to parse the user's message into the expected format
M.parse_message = function(opts)
  local message_content = {}

  -- Check if the clipboard supports image pasting and add image data
  if Clipboard.support_paste_image() and opts.image_paths then
    for _, image_path in ipairs(opts.image_paths) do
      local image_data = {
        inline_data = {
          mime_type = "image/png", -- Define the image type
          data = Clipboard.get_base64_content(image_path), -- Convert image to base64
        },
      }
      table.insert(message_content, image_data) -- Add the image data to the message
    end
  end

  -- Insert user prompts into the message content
  table.insert(message_content, { text = table.concat(opts.user_prompts, "\n") })

  -- Return the formatted message for Hugging Face API
  return {
    inputs = message_content[1].text, -- API expects the "inputs" key
    parameters = opts.parameters or {}, -- Use provided parameters if available
  }
end

-- Function to parse the response from the Hugging Face API
M.parse_response = function(data_stream, _, opts)
  local ok, json = pcall(vim.json.decode, data_stream) -- Attempt to decode JSON

  if not ok then
    opts.on_complete(json) -- Handle decoding errors
    return
  end

  -- Process the API response based on the returned data
  if json.generated_text then
    opts.on_chunk(json.generated_text) -- Call the chunk handler for generated text
  elseif json.error then
    opts.on_complete(json.error) -- Handle API errors
  else
    opts.on_complete(nil) -- No response received
  end
end

-- Function to construct curl arguments for the API request
M.parse_curl_args = function(provider, code_opts)
  local base, body_opts = P.parse_config(provider) -- Parse provider configuration

  -- Extend body options with defaults for temperature and max_tokens
  body_opts = vim.tbl_deep_extend("force", body_opts, {
    temperature = body_opts.temperature or 0.7,
    max_tokens = body_opts.max_tokens or 100,
  })

  -- Return the curl arguments required for the API request
  return {
    url = "https://api-inference.huggingface.co/models/" .. base.model, -- API URL
    headers = {
      ["Content-Type"] = "application/json", -- Set content type to JSON
      ["Authorization"] = "Bearer " .. provider.parse_api_key(), -- Add API key
    },
    body = vim.tbl_deep_extend("force", {}, M.parse_message(code_opts), body_opts), -- Build the request body
    insecure = base.allow_insecure, -- Use insecure flag if needed
    proxy = base.proxy, -- Use proxy if defined
  }
end

-- Return the module
return M
]]

