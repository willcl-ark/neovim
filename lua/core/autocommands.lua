local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local asciidoctor = augroup("asciidoctor", { clear = true })
autocmd("FileType", {
  pattern = "asciidoctor",
  command = "setlocal spell spelllang=en_gb wrap colorcolumn= linebreak",
  group = asciidoctor,
})

-- Autoresize
local autoresize = augroup("autoresize", { clear = true })
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
  group = autoresize,
})

-- General
local general = augroup("general", { clear = true })
autocmd("FileType", {
  pattern = "help,man,lspinfo",
  command = "nnoremap <silent> <buffer> q :close<CR>",
  group = general,
})

-- Highlight
local highlight = augroup("TextYankPost", { clear = true })
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Search", timeout = 500 })
  end,
  group = highlight,
})

-- Git
local git = augroup("git", { clear = true })
autocmd("FileType", {
  pattern = "gitcommit",
  command = "setlocal textwidth=72 colorcolumn=72 colorcolumn+=50 wrap",
  group = git,
})
autocmd("BufRead", {
  pattern = "*.orig",
  command = "setlocal readonly",
  group = git,
})

-- Mail
local mail = augroup("mail", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "/tmp/mutt/*",
  command = "setfiletype mail",
  group = mail,
})
autocmd("FileType", {
  pattern = "mail",
  command = "setlocal spell spelllang=en_gb textwidth=72 fo+=w",
  group = mail,
})

-- Markdown
local markdown = augroup("markdown", { clear = true })
autocmd("FileType", {
  pattern = "markdown",
  command = "setlocal wrap spell spelllang=en_gb",
  group = markdown,
})

local yaml = augroup("yaml", { clear = true })
autocmd("FileType", {
  pattern = "yaml",
  command = "setlocal wrap spell spelllang=en_gb",
  group = yaml,
})
