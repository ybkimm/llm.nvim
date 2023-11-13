local completion = require("llm.completion")
local config = require("llm.config")

local M = {
  setup_done = false,
}

local function accept_suggestion(accept_keymap)
  if not completion.suggestion then
    return vim.api.nvim_replace_termcodes(accept_keymap, true, true, true)
  end
  vim.schedule(completion.complete)
end

local function dismiss_suggestion(dismiss_keymap)
  if not completion.suggestion then
    return vim.api.nvim_replace_termcodes(dismiss_keymap, true, true, true)
  end
  vim.schedule(function()
    completion.cancel()
    completion.suggestion = nil
  end)
end

function M.setup()
  if M.setup_done then
    return
  end

  local accept_keymap = config.get().accept_keymap
  local dismiss_keymap = config.get().dismiss_keymap

  local function invoke_accept()
    return accept_suggestion(accept_keymap)
  end

  local function invoke_dismiss()
    return dismiss_suggestion(dismiss_keymap)
  end

  vim.keymap.set("i", accept_keymap,  invoke_accept,  { expr = true })
  vim.keymap.set("n", accept_keymap,  invoke_accept,  { expr = true })
  vim.keymap.set("i", dismiss_keymap, invoke_dismiss, { expr = true })
  vim.keymap.set("n", dismiss_keymap, invoke_dismiss, { expr = true })

  M.setup_done = true
end

return M
