-- Add which-key for better keymap discovery
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependncies = {
      "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- Minimal configuration with default settings
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
    -- Group labels using the new recommended spec format
    { "<leader>a", group = "AI/Assistant" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Diagnostics/Debug" },
    { "<leader>f", group = "Format/Find" },
    { "<leader>g", group = "Git" },
    { "<leader>r", group = "Refactor/Rename" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Toggle" },
    { "<leader>w", group = "Workspace/Window" },
  },
}
