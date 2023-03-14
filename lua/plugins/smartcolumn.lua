return {
  "m4xshen/smartcolumn.nvim",
  config = function()
    require("smartcolumn").setup({
      colorcolumn = 80,
      disabled_filetypes = { "help", "text", "markdown" },
      custom_colorcolumn = { rust = 120, cpp = 100 },
      limit_to_window = true,
      limit_to_line = false,
    })
  end,
  event = { "BufRead", "BufNewFile" },
}
