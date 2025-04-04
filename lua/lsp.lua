-- Merge default, blink.cmp and a few extra capabilites
local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
  }
}

capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }

-- Default config to apply to lsps.
-- See :h lsp-config for override precedence.
vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { ".git" },
})

-- Enabled LSP servers
-- See each server config in lsp/*.lua
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
  -- Only use virtual lines for errors
  virtual_lines = {
    current_line = true,
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
  },
  -- Use virtual text otherwise
  virtual_text = {
    severity = {
      max = vim.diagnostic.severity.WARN,
    },
  },
})

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
      -- stylua: ignore start
      -- Diagnostic keymaps
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      end)

      -- LSP keymaps
      local nmap = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. (desc or "") })
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
      nmap("<leader>gs", telescope.lsp_document_symbols,          "[G]oto [S]symbols")
      nmap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]symbols")
      nmap("<leader>sd", telescope.diagnostics,                   "[S]earch [D]iagnostics")
      nmap("gI",         telescope.lsp_implementations,           "[G]oto [I]mplementations")
      nmap("gd",         telescope.lsp_definitions,               "[G]oto [D]definitions")
      nmap("gt",         telescope.lsp_type_definitions,          "[G]oto [T]ype Definition")

      -- Workspace folder management
      nmap("<leader>wa", vim.lsp.buf.add_workspace_folder,        "[W]orkspace [A]dd Folder")
      nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder,     "[W]orkspace [R]emove Folder")
      nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,                                                        "[W]orkspace [L]ist Folders")
      -- stylua: ignore end
    end
  end,
})
