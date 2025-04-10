return {
  "yetone/avante.nvim",
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Ask Avante" },
  },
  build = "make BUILD_FROM_SOURCE=true luajit",
  opts = {
    ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    provider = "claude",
    auto_suggestions_provider = "claude",
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-latest",
      temperature = 0.2, -- This could be set to "0" for programming, potentially. But 0.2 gets us a little "creativity"
      max_tokens = 4096,
    },
    hints = { enabled = false },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
  },
}
