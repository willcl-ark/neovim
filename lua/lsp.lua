-- Default root marker for all LSPs
vim.lsp.config("*", {
  root_markers = { ".git" },
})

-- Enabled LSP servers
vim.lsp.enable({ "basedpyright" })
vim.lsp.enable({ "clangd" })
vim.lsp.enable({ "cmake" })
vim.lsp.enable({ "fish_lsp" })
vim.lsp.enable({ "gopls" })
vim.lsp.enable({ "lua_ls" })
vim.lsp.enable({ "nil_ls" })
vim.lsp.enable({ "ruff" })
vim.lsp.enable({ "rust_analyzer" })
vim.lsp.enable({ "zls" })

-- Diagnostics --
vim.diagnostic.config({
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})

-- Autocomplete
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- Ensure client exists before checking methods and accessing properties
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- Main LSP
local M = {
  -- Capabilities
  client_capabilities = function()
    -- Get Neovim's built-in capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Add cmp_nvim_lsp capabilities (better completion)
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Add some extra capabilities
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }

    return capabilities
  end,

  -- LSP keymaps and autocommands
  on_attach = function(_, bufnr)
    -- stylua: ignore start
    -- Diagnostic keymaps
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
  end,
}

-- a simple handler for registerCapability
local old_handlers = vim.lsp.handlers
vim.lsp.handlers = setmetatable({
  ["client/registerCapability"] = function()
    -- Empty handler that responds with 'null'
    -- needed to silence some Ruff log error
    return vim.NIL
  end,
}, {
  __index = old_handlers,
})

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
