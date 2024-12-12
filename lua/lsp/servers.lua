local M = {}

function M.get_clangd_config()
  local function get_compile_commands_dir()
    local root_dir = vim.fn.getcwd()
    local dirs = { root_dir .. "/build/debug", root_dir .. "/build" }
    for _, dir in ipairs(dirs) do
      local cc_path = dir .. "/compile_commands.json"
      if vim.fn.filereadable(cc_path) == 1 then
        return dir
      end
    end
    return nil
  end

  local clangd_cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" }
  local cc_dir = get_compile_commands_dir()
  if cc_dir then
    table.insert(clangd_cmd, "--compile-commands-dir=" .. cc_dir)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.offsetEncoding = "utf-8"

  return {
    capabilities = capabilities,
    cmd = clangd_cmd,
  }
end

function M.get_pyright_config(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          ignore = { "*" },
        },
      },
    },
  }
end

function M.get_ruff_config(capabilities)
  local function on_attach(client, _)
    client.server_capabilities.hoverProvider = false
  end

  return {
    on_attach = on_attach,
    capabilities = capabilities,
    trace = "messages",
    init_options = {
      settings = {
        logLevel = "debug",
      },
    },
  }
end

return M
