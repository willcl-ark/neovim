return {
  "neovim/nvim-lspconfig", -- LSP Configuration & Plugins
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Useful status updates for LSP
    "j-hui/fidget.nvim",

    -- Formatting and linting
    "jose-elias-alvarez/null-ls.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Diagnostic keymaps
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

    -- LSP settings.
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- Create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
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

      -- Lesser used LSP functionality
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
      nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
      nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[W]orkspace [L]ist Folders")

      -- Function to select only formatters from Null-ls and avoid conflicts from the LSP
      local lsp_formatting = function(bufnr)
        vim.lsp.buf.format({
          filter = function(client)
            return client.name == "null-ls"
          end,
          bufnr = bufnr,
        })
      end

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        if vim.lsp.buf.format then
          lsp_formatting(bufnr)
        elseif vim.lsp.buf.formatting then
          vim.lsp.buf.formatting()
        end
      end, { desc = "Format current buffer with null-ls formatter" })

      -- Format buffer using LSP format
      nmap("<leader>df", ":Format<CR>", "[D]o [F]ormat")
    end -- END function() on_attach

    -- Setup mason so it can manage external tooling
    require("mason").setup()

    -- Enable the following language servers and have Mason install them automagically if missing
    -- Install others onto system path manually. This helps us use tools at same version as compiler
    local servers = { "pyright", "lua_ls", "gopls", "cmake" }
    require("mason-lspconfig").setup({ ensure_installed = servers })

    -- nvim-cmp supports additional completion capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local lspconfig = require("lspconfig")
    require("mason-lspconfig").setup_handlers({
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      -- Handler overrides for specific LSPs
      ["rust_analyzer"] = function()
        lspconfig["rust_analyzer"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { "rust-analyzer" },
        })
        require("rust-tools").setup({})
      end,
      ["clangd"] = function()
        -- hack to silence clangd multiple offset encodings warnings
        local clangd_capabilities = capabilities
        clangd_capabilities.offsetEncoding = "utf-8"

        lspconfig["clangd"].setup({
          on_attach = on_attach,
          capabilities = clangd_capabilities,
          cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
        })
      end,
      ["lua_ls"] = function()
        -- Make runtime files discoverable to the server
        local runtime_path = vim.split(package.path, ";")
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")

        lspconfig["lua_ls"].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                path = runtime_path,
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        })
      end,
    })

    -- Turn on lsp status information (bottom right)
    require("fidget").setup()

    -- Null-ls
    local null_ls = require("null-ls")
    local sources = {
      null_ls.builtins.code_actions.shellcheck,
      null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.diagnostics.gitlint,
      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.formatting.black.with({
        extra_args = { "--line-length=120" },
      }),
      null_ls.builtins.formatting.clang_format.with({
        filetypes = { "cpp", "hpp", "c", "h" },
      }),
      null_ls.builtins.formatting.fish_indent,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.prettier.with({
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "css",
          "scss",
          "less",
          "html",
          "json",
          "jsonc",
          "yaml",
          -- "markdown",
          "markdown.mdx",
          "graphql",
          "handlebars",
        },
      }),
      null_ls.builtins.formatting.rustfmt,
      null_ls.builtins.formatting.shfmt.with({
        extra_filetypes = { "bash" },
      }),
      null_ls.builtins.formatting.stylua,
    }

    null_ls.setup({ sources = sources })
  end,
}
