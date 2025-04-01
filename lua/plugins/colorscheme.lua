local M = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    cmd = "Telescope colorscheme",
    opts = {
      integrations = {
        telescope = true,
        mason = true,
        cmp = true,
        treesitter = true,
      },
    },
  },
  {
    "navarasu/onedark.nvim",
    cmd = "Telescope colorscheme",
    opts = {
      style = "dark",
      toggle_style_key = "<leader>ts",
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },
      diagnostics = {
        darker = true,
        undercurl = true,
        background = true,
      },
    },
  },
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    lazy = false, -- Load immediately
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.g.gruvbox_material_better_performance = 1
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    cmd = "Telescope colorscheme",
  },
  {
    "lunarvim/synthwave84.nvim",
    cmd = "Telescope colorscheme",
  },
}

function M.setup_colorscheme()
  vim.cmd([[colorscheme gruvbox-material]])
end

return M
