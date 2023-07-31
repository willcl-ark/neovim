return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "simrat39/rust-tools.nvim",
      "p00f/clangd_extensions.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Diagnostic keymaps
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(_, bufnr)
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

      -- nvim-cmp supports additional completion capabilities
      --local capabilities = vim.lsp.protocol.make_client_capabilities()
      --capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
        ["lua_ls"] = function()
          -- Make runtime files discoverable to the server
          local runtime_path = vim.split(package.path, ";")
          table.insert(runtime_path, "lua/?.lua")
          table.insert(runtime_path, "lua/?/init.lua")

          lspconfig.lua_ls.setup({
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
      -- If the server is not installed by Mason, set it up manually

      -- hack to silence clangd multiple offset encodings warnings
      local clangd_capabilities = require("cmp_nvim_lsp").default_capabilities()
      clangd_capabilities.offsetEncoding = "utf-8"

      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = clangd_capabilities,
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
      })

      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      lspconfig.cmake.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- rust-tools sets up rust-analyzer for us
      require("rust-tools").setup({
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = {
            "rust-analyzer",
          },
        },
      })

      -- Inlay hints (and more) for cpp
      require("clangd_extensions").setup({
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    config = function()
      -- Enable the following language servers and have Mason install them automagically if missing
      -- Install others onto system path manually. This helps us use tools at same version as compiler
      local servers = { "lua_ls" }
      require("mason-lspconfig").setup({ ensure_installed = servers })
    end,
  },
  {
    -- Useful status updates for LSP
    "j-hui/fidget.nvim",
    -- Turn on lsp status information (bottom right)
    lazy = true,
    config = true,
    tag = "legacy",
  },
  {
    -- Formatting and linting
    "jose-elias-alvarez/null-ls.nvim",
    -- lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      local sources = {
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.ruff.with({
          extra_args = {
            "--ignore E501", -- ignore line-too-long
            -- "--line-length 88",  -- same as black
          },
        }),
        null_ls.builtins.formatting.yapf.with({
          condition = function(utils) -- Use yapf formatter for Bitcoin Core
            return utils.root_matches("bitcoin") ~= nil
          end,
        }),
        null_ls.builtins.formatting.ruff.with({
          condition = function(utils) -- Don't use ruff formatter with Bitcoin Core
            return utils.root_matches("bitcoin") == nil
          end,
        }),
        -- null_ls.builtins.formatting.black.with({
        --   extra_args = { "--line-length=120" },
        -- }),
        null_ls.builtins.formatting.clang_format.with({
          filetypes = { "cpp", "hpp", "c", "h" },
        }),
        null_ls.builtins.formatting.fish_indent,
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
            -- "yaml",
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
        null_ls.builtins.formatting.yamlfmt,
      }
      local on_attach = function(_, bufnr)
        -- disable formatexpr for gq https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")

        -- only use formatters from null-ls for Format cmd
        local lsp_formatting = function(buf)
          vim.lsp.buf.format({
            bufnr = buf,
            filter = function(client)
              return client.name == "null-ls"
            end,
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
        vim.keymap.set("n", "<leader>df", ":Format<CR>", { buffer = bufnr, desc = "[D]o [F]ormat" })
      end

      null_ls.setup({
        debug = false,
        sources = sources,
        on_attach = on_attach,
      })
    end,
  },
}
