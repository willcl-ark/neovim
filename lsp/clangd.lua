---@type vim.lsp.Config
return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".git"},
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  single_file_support = true,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
  },
}
