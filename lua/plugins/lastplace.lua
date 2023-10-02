return {
  -- Open files in last edited place
  "ethanholz/nvim-lastplace",
  branch = "main",
  opts = {
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    lastplace_open_folds = true,
  },
}
