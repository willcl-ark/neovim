local parsers = {
  "bash",
  "c",
  "cpp",
  "dockerfile",
  "fish",
  "go",
  "html",
  "lua",
  "markdown",
  "python",
  "regex",
  "rust",
  "typescript",
  "vim",
  "yaml",
  "vimdoc",
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  cmd = {
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSUpdate",
    "TSUpdateSync",
    "TSUninstall",
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("core_treesitter", { clear = true }),
      pattern = {
        "bash",
        "c",
        "cpp",
        "dockerfile",
        "fish",
        "go",
        "help",
        "html",
        "lua",
        "markdown",
        "python",
        "regex",
        "rust",
        "sh",
        "typescript",
        "vim",
        "yaml",
      },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = parsers,
      parser_install_dir = vim.fn.stdpath("data") .. "/site",
      highlight = { enable = false },
      indent = { enable = false },
    })
  end,
}
