local methods = vim.lsp.protocol.Methods

local M = {}

--- Returns the editor's capabilities + some overrides.
M.client_capabilities = function()
  return vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
    require("cmp_nvim_lsp").default_capabilities(),
    {
      workspace = {
        -- PERF: didChangeWatchedFiles is too slow.
        -- TODO: Remove this when https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed.
        didChangeWatchedFiles = { dynamicRegistration = false },
      },
    }
  )
end

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  -- Diagnostic keymaps
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
  -- TODO: can we check if enabled and have a toggle?
  vim.keymap.set("n", "<leader>d", vim.diagnostic.disable)
  vim.keymap.set("n", "<leader>de", vim.diagnostic.enable)

  -- Set mappings less verbosely
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinitions")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementations")
  nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinitions")
  nmap("<leader>gs", require("telescope.builtin").lsp_document_symbols, "[G]oto [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end -- END function() on_attach

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2)
      return diag1.severity > diag2.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

-- Update mappings when registering dynamic capabilities.
-- Use the string "client/registerCapability" directly
local register_capability_key = "client/registerCapability"

-- Save the existing handler if it exists
local existing_handler = vim.lsp.handlers[register_capability_key]

-- Define custom handler
local custom_handler = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())

  -- Call the existing handler if it was previously defined
  if existing_handler then
    existing_handler(err, res, ctx)
  end
end

-- Assign your custom handler to the LSP handlers table
vim.lsp.handlers[register_capability_key] = custom_handler

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

return M
