return {
  "nvim-treesitter/nvim-treesitter-context",
  config = true,
  dependencies = {
      "nvim-treesitter/nvim-treesitter",
  },
  event = { "BufRead", "BufNewFile" },
}
