local M = {}

-- Root pattern search implementation
function M.root_pattern(...)
  local patterns = {...}
  return function(startpath)
    -- Convert relative path to absolute if needed
    local path = vim.fn.fnamemodify(startpath, ':p')
    
    -- Navigate up the directory tree
    local function find_root(current_path)
      -- Check for match in current directory
      for _, pattern in ipairs(patterns) do
        local glob_pattern = current_path .. '/' .. pattern
        if #vim.fn.glob(glob_pattern, false, true) > 0 then
          return current_path
        end
      end
      
      -- Move up to parent directory
      local parent = vim.fn.fnamemodify(current_path, ':h')
      if parent == current_path then
        return nil -- Reached root directory
      end
      
      return find_root(parent)
    end
    
    return find_root(vim.fn.fnamemodify(path, ':h'))
  end
end

-- Properly handle capability registration
function M.setup_handlers()
  local register_capability_key = "client/registerCapability"
  
  -- Store original handler
  local original_handler = vim.lsp.handlers[register_capability_key]
  
  -- Replace with our handler that properly responds
  vim.lsp.handlers[register_capability_key] = function(err, result, ctx, config)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    
    -- Always send an empty response to acknowledge the capability registration
    ctx.client.notify_reply(ctx.id, nil, nil)
    
    -- Call original handler if it exists
    if original_handler then
      original_handler(err, result, ctx, config)
    end
  end
end

return M