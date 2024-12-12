return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "fidget", -- setup using lua/plugins/fidget.lua
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("lsp").client_capabilities
      -- vim.lsp.set_log_level("info")

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
        ["ruff"] = function()
          local ruff_on_attach = function(client, _)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
          lspconfig.ruff.setup({
            on_attach = ruff_on_attach,
            capabilities = capabilities(),
            trace = "messages",
            init_options = {
              settings = {
                logLevel = "debug",
              },
            },
          })
        end,
      })

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

      -- Helper function to safely setup LSP
      local function setup_lsp(server, opts)
        opts = opts or { capabilities = capabilities() }
        local ok, _ = pcall(function()
          lspconfig[server].setup(opts)
        end)
        if not ok then
          vim.notify("LSP " .. server .. " not found", vim.log.levels.DEBUG)
        end
      end

      -- Setup clangd with special capabilities
      setup_lsp("clangd", {
        capabilities = clangd_capabilities,
        cmd = get_clangd_cmd(), -- generate the cmd value with appropriate compile_commands
      })

      -- Setup other LSPs
      setup_lsp("cmake")
      setup_lsp("gopls")
      setup_lsp("lua_ls")
      setup_lsp("nil_ls")
      setup_lsp("pyright", {
        capabilities = capabilities(),
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
          },
        },
      })
      setup_lsp("ruff")
      setup_lsp("zls")

      -- Inlay hints (and more) for cpp
      pcall(function()
        require("clangd_extensions").setup({
          server = {
            capabilities = capabilities(),
          },
        })
      end)
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
      -- Map of LSP server names to their executable names
      local server_binaries = {
        clangd = "clangd",
        cmake = "cmake-language-server",
        gopls = "gopls",
        lua_ls = "lua-language-server",
        nil_ls = "nil",
        pyright = "pyright",
        ruff = "ruff",
        zls = "zls",
      }

      -- Function to check if a command exists in PATH
      local function command_exists(cmd)
        local handle = io.popen("command -v " .. cmd .. ' >/dev/null 2>&1 && echo "true" || echo "false"')
        if handle then
          local result = handle:read("*l")
          handle:close()
          return result == "true"
        end
        return false
      end

      -- Only include servers  for install that aren't already in $PATH
      local servers_to_install = {}
      for server, binary in pairs(server_binaries) do
        if binary == "nil" then
          goto continue
        end
        if not command_exists(binary) then
          table.insert(servers_to_install, server)
          vim.notify("Will install " .. server .. " via Mason (not found in PATH)", vim.log.levels.INFO)
        end
        ::continue::
      end

      require("mason-lspconfig").setup({
        ensure_installed = servers_to_install,
        automatic_installation = false,
      })
    end,
  },
}
