return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  enable = false,
  config = function()
    require("lsp_lines").setup({
      vim.diagnostic.config({ virtual_text = true }),
      vim.diagnostic.config({ virtual_lines = false }),
    })
    function ToggleLspLines()
      vim.diagnostic.config({ virtual_text = not vim.diagnostic.config()["virtual_text"] })
      vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config()["virtual_lines"] })
    end

    vim.keymap.set("", "<Leader>l", ToggleLspLines, { desc = "[L]sp_lines toggle" })
  end,
  lazy = true,
  name = "lsp_lines",
}
