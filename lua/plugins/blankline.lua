return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  main = "ibl",
  config = function()
    local highlight = {
      "Red",
      "Yellow",
      "Blue",
      "Orange",
      "Green",
      "Violet",
      "Cyan",
    }

    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "Red", { fg = "#EA6962" })
      vim.api.nvim_set_hl(0, "Yellow", { fg = "#D8A657" })
      vim.api.nvim_set_hl(0, "Blue", { fg = "#7DAEA3" })
      vim.api.nvim_set_hl(0, "Orange", { fg = "#E78A4E" })
      vim.api.nvim_set_hl(0, "Green", { fg = "#A9B665" })
      vim.api.nvim_set_hl(0, "Violet", { fg = "#D3869B" })
      vim.api.nvim_set_hl(0, "Cyan", { fg = "#89B482" })
    end)

    require("ibl").setup({ indent = { highlight = highlight, char = { "│" } }})
  end,
}
