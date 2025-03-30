-- lua/core/autocmd.lua
local M = {}

function M.setup()
  local function create_augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
  end

  -- File type specific settings
  local filetype = create_augroup("filetype_settings")
  vim.api.nvim_create_autocmd("FileType", {
    group = filetype,
    pattern = "help,man,lspinfo",
    callback = function()
      vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = filetype,
    pattern = "gitcommit",
    callback = function()
      vim.opt_local.textwidth = 72
      vim.opt_local.colorcolumn = "72,50"
      vim.opt_local.wrap = true
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = filetype,
    pattern = "gitrebase",
    callback = function()
      vim.keymap.set("n", "<C-e>", ":%s/pick/edit<CR>", { buffer = true })
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = filetype,
    pattern = { "markdown", "yaml" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_gb"
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = filetype,
    pattern = "asciidoctor",
    callback = function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_gb"
      vim.opt_local.wrap = true
      vim.opt_local.colorcolumn = ""
      vim.opt_local.linebreak = true
    end,
  })

  -- Mail settings
  local mail = create_augroup("mail_settings")
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = mail,
    pattern = "/tmp/mutt/*",
    callback = function()
      vim.opt_local.filetype = "mail"
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = mail,
    pattern = "mail",
    callback = function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_gb"
      vim.opt_local.textwidth = 72
      vim.opt_local.formatoptions:append("w")
    end,
  })

  -- Window management
  local window = create_augroup("window_management")
  vim.api.nvim_create_autocmd("VimResized", {
    group = window,
    pattern = "*",
    command = "tabdo wincmd =",
  })

  -- Highlighting
  local highlight = create_augroup("highlight_settings")
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = highlight,
    pattern = "*",
    callback = function()
      vim.highlight.on_yank({ higroup = "Search", timeout = 500 })
    end,
  })

  -- Git settings
  local git = create_augroup("git_settings")
  vim.api.nvim_create_autocmd("BufRead", {
    group = git,
    pattern = "*.orig",
    callback = function()
      vim.opt_local.readonly = true
    end,
  })
end

return M
