local M = {}

-- Handle capability registration
function M.setup_handlers()
  -- Get the key for capability registration
  local register_capability_key = "client/registerCapability"

  -- Replace the handler with a simple version that just responds to the server
  vim.lsp.handlers[register_capability_key] = function(_, _, ctx)
    -- This is the most basic handler possible - it just sends an empty response
    vim.lsp.buf_request_sync(ctx.bufnr or 0, "client/registerCapability", {}, 1000)

    return true
  end
end

return M

