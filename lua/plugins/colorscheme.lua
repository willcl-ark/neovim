function SetupColorScheme()
  vim.cmd.colorscheme("gruvbox-material")
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    cmd = "Telescope colorscheme",
    config = function()
      require("catppuccin").setup({
        integrations = {
          telescope = true,
          mason = true,
          cmp = true,
          treesitter = true,
        },
      })
    end,
  },
  {
    "navarasu/onedark.nvim",
    cmd = "Telescope colorscheme",
    config = function()
      require("onedark").setup({
        default_config = {
          -- Main options --
          style = "dark", -- choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
          toggle_style_key = "<leader>ts",
          toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
          transparent = false, -- don't set background
          term_colors = true, -- if true enable the terminal
          ending_tildes = false, -- show the end-of-buffer tildes

          -- Changing Formats --
          code_style = {
            comments = "italic",
            keywords = "none",
            functions = "none",
            strings = "none",
            variables = "none",
          },

          -- Custom Highlights --
          colors = {}, -- Override default colors
          highlights = {}, -- Override highlight groups

          -- Plugins Related --
          diagnostics = {
            darker = true, -- darker colors for diagnostic
            undercurl = true, -- use undercurl for diagnostics
            background = true, -- use background color for virtual text
          },
        },
      })
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
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      -- Available values: 'hard', 'medium'(default), 'soft'
      vim.g.gruvbox_material_background = "medium"
      -- Color virtual text
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.g.gruvbox_material_better_performance = 1
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
}
