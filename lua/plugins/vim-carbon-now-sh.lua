return {
  "kristijanhusak/vim-carbon-now-sh",
  config = function()
      vim.keymap.set("v", "<F5>", ":CarbonNowSh<CR>")
  end,
}
