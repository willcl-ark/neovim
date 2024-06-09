return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "fidget", -- setup using lua/plugins/fidget.lua
            "lsp_lines",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("lsp").client_capabilities

            require("mason-lspconfig").setup_handlers({
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function(server_name) -- default handler (optional)
                    lspconfig[server_name].setup({
                        capabilities = capabilities(),
                    })
                end,
                -- Handler overrides for specific LSPs
                ["lua_ls"] = function()
                    -- Make runtime files discoverable to the server
                    local runtime_path = vim.split(package.path, ";")
                    table.insert(runtime_path, "lua/?.lua")
                    table.insert(runtime_path, "lua/?/init.lua")

                    lspconfig.lua_ls.setup({
                        capabilities = capabilities(),
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
                ["ruff"] = function()
                    local ruff_on_attach = function(client, _)
                        -- Disable hover in favor of Pyright
                        client.server_capabilities.hoverProvider = false
                    end

                    lspconfig.ruff.setup({
                        on_attach = ruff_on_attach,
                        capabilities = capabilities(),
                    })
                end,
            })
            -- If the server is not installed by Mason, set it up manually

            -- hack to silence clangd multiple offset encodings warnings
            local clangd_capabilities = require("cmp_nvim_lsp").default_capabilities()
            clangd_capabilities.offsetEncoding = "utf-8"

            local function get_compile_commands_dir()
                local root_dir = vim.fn.getcwd()

                -- check build/debug/ and then build/ for compile_commands.json in that order
                local dirs = { root_dir .. "/build/debug", root_dir .. "/build" }
                for _, dir in ipairs(dirs) do
                    local cc_path = dir .. "/compile_commands.json"
                    if vim.fn.filereadable(cc_path) == 1 then
                        return dir
                    end
                end
                return nil -- fallback to clangd's default behavior
            end

            local function get_clangd_cmd()
                local clangd_cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" }
                local cc_dir = get_compile_commands_dir()
                if cc_dir then
                    table.insert(clangd_cmd, "--compile-commands-dir=" .. cc_dir)
                end
                return clangd_cmd
            end

            lspconfig.clangd.setup({
                capabilities = clangd_capabilities,
                cmd = get_clangd_cmd(), -- generate the cmd value with appropriate compile_commands
            })

            lspconfig.cmake.setup({ capabilities = capabilities() })
            lspconfig.gopls.setup({ capabilities = capabilities() })
            lspconfig.pyright.setup({
                capabilities = capabilities(),
                settings = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            -- Ignore all files for analysis to exclusively use Ruff for linting
                            ignore = { '*' },
                        },
                    },
                },
            })
            lspconfig.ruff.setup({ capabilities = capabilities() })
            lspconfig.typos_lsp.setup({ capabilities = capabilities() })
            lspconfig.zls.setup({ capabilities = capabilities() })

            -- Inlay hints (and more) for cpp
            require("clangd_extensions").setup({
                server = {
                    capabilities = capabilities(),
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
            local servers = { "lua_ls", "typos_lsp" }
            require("mason-lspconfig").setup({ ensure_installed = servers })
        end,
    },
}
