---@type vim.lsp.Config
return {
  cmd = { "cmake-language-server" },
  filetypes = { "cmake" },
  root_markers = { "CMakePresets.json", "CTestConfig.cmake", ".git", "build*", "cmake" },
  single_file_support = true,
  settings = {
    init_options = {
      buildDirectory = "build",
    },
  },
}
