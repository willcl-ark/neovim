return {
  "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
  -- See `:help indent_blankline.txt`
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    vim.opt.list = true
    vim.cmd([[highlight IndentBlanklineIndent1 guifg=#f38ba8 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent2 guifg=#f9e2af gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent3 guifg=#a6e3a1 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent4 guifg=#89b4fa gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent5 guifg=#f5c2e7 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent6 guifg=#89dceb gui=nocombine]])
    require("indent_blankline").setup({
      show_current_context = true,
      show_current_context_start = true,
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
      },
    })
  end,
}
