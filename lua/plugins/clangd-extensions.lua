return {
  {
  "p00f/clangd_extensions.nvim",
    -- only load this plugin for cpp files
    event = { "BufReadPre *.cpp", "BufNewFile *.cpp" },
  },
}
