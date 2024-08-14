return {
  "OXY2DEV/markview.nvim",
  lazy = true,
  ft = "markdown",
  keys = {
    { "<leader>m", "<cmd>Markview toggle<cr>", desc = "Toggle Markview" },
  },
  config = function()
    require("markview").setup()
    -- Disable Markview by default
    require("markview").state.enable = false
    -- Alternatively, you can use the command:
    -- vim.cmd("Markview disableAll")
  end,
}
