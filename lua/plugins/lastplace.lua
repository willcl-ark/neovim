return {
  -- Open files in last edited place
  "ethanholz/nvim-lastplace",
  branch="main",
  config = function()
    require("nvim-lastplace").setup({
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
      lastplace_open_folds = true,
    })
  end,
}
