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
  init = function()
    vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { desc = "[D]iff [O]pen" })
    vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory<CR>", { desc = "[D]iff file [H]istory" })
    vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "[D]iff [C]lose" })
    vim.keymap.set("n", "<leader>dp", "<cmd>DiffviewToggleFiles<CR>", { desc = "[D]iff [T]oggle files panel" })
  end,
}
