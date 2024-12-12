local M = {}

-- LSP capabilities
function M.client_capabilities()
  return vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities(),
    {
      workspace = {
        didChangeWatchedFiles = { dynamicRegistration = false },
      },
    }
  )
end

-- LSP keymaps and autocommands
function M.on_attach(_, bufnr)
  -- stylua: ignore start
  -- Diagnostic keymaps
  vim.keymap.set("n", "[d",        vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d",        vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
  vim.keymap.set("n", "<leader>d", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end)

  -- LSP keymaps
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. (desc or "") })
  end

  -- Core LSP functionality
  nmap("<leader>rn", vim.lsp.buf.rename,                      "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action,                 "[C]ode [A]ction")
  nmap("K",          vim.lsp.buf.hover,                       "Hover Do[K]umentation")
  nmap("<C-k>",      vim.lsp.buf.signature_help,              "Signature Do[K]umentation")
  nmap("gD",         vim.lsp.buf.declaration,                 "[G]oto [D]eclaration")

  -- Telescope-based LSP actions
  local telescope = require("telescope.builtin")
  nmap("gr",         telescope.lsp_references,                "[G]oto [R]eferences")
  nmap("<leader>gs", telescope.lsp_document_symbols,          "[G]oto [S]ymbols")
  nmap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
  nmap("<leader>sd", telescope.diagnostics,                   "[S]earch [D]iagnostics")
  nmap("gI",         telescope.lsp_implementations,           "[G]oto [I]mplementations")
  nmap("gd",         telescope.lsp_definitions,               "[G]oto [D]efinitions")
  nmap("gt",         telescope.lsp_type_definitions,          "[G]oto [T]ype Definition")

  -- Workspace folder management
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder,        "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder,     "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end,                                                        "[W]orkspace [L]ist Folders")
  -- stylua: ignore end
end

-- Dynamic capability registration
local register_capability_key = "client/registerCapability"
local existing_handler = vim.lsp.handlers[register_capability_key]

vim.lsp.handlers[register_capability_key] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client then
    M.on_attach(client, vim.api.nvim_get_current_buf())
    if existing_handler then
      existing_handler(err, res, ctx)
    end
  end
end

-- LSP attach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      M.on_attach(client, args.buf)
    end
  end,
})

return M
