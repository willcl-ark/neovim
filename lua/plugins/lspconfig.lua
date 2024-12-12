return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "fidget",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("lsp").client_capabilities
      local servers = require("lsp.servers")

      -- Setup handlers
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities(),
          })
        end,
        ["ruff"] = function()
          lspconfig.ruff.setup(servers.get_ruff_config(capabilities()))
        end,
      })

      -- Setup servers with special configs
      lspconfig.clangd.setup(servers.get_clangd_config())
      lspconfig.pyright.setup(servers.get_pyright_config(capabilities()))

      -- Setup basic servers
      local basic_servers = { "cmake", "gopls", "lua_ls", "nil_ls", "zls" }
      for _, server in ipairs(basic_servers) do
        local ok = pcall(function()
          lspconfig[server].setup({ capabilities = capabilities() })
        end)
        if not ok then
          vim.notify("LSP " .. server .. " not found", vim.log.levels.DEBUG)
        end
      end

      -- Setup clangd extensions if available
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
    opts = function()
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

      local function command_exists(cmd)
        local handle = io.popen("command -v " .. cmd .. ' >/dev/null 2>&1 && echo "true" || echo "false"')
        if handle then
          local result = handle:read("*l")
          handle:close()
          return result == "true"
        end
        return false
      end

      local servers_to_install = {}
      for server, binary in pairs(server_binaries) do
        if binary ~= "nil" and not command_exists(binary) then
          table.insert(servers_to_install, server)
          vim.notify("Will install " .. server .. " via Mason (not found in PATH)", vim.log.levels.INFO)
        end
      end

      return {
        ensure_installed = servers_to_install,
        automatic_installation = false,
      }
    end,
  },
}
