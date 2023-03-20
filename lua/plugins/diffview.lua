return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = { "BufRead", "BufNewFile" },
  config = function()
    require("diffview").setup({
      file_panel = {
        listing_style = "list",
      },
    })
  end,
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "[D]iffview ]O]pen" },
    { "<leader>dh", "<cmd>DiffviewFileHistory<CR>", desc = "[D]iff file [H]istory" },
    { "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "[D]iff [C]lose" },
    { "<leader>dp", "<cmd>DiffviewToggleFiles<CR>", desc = "[D]iff [T]oggle files panel" },
  },
}
