---@type vim.lsp.Config
return {
  cmd = { "fish-lsp", "start" },
  filetypes = { "fish" },
  cmd_env = { fish_lsp_show_client_popups = false },
  root_markers = { ".git" },
  single_file_support = true,
}
