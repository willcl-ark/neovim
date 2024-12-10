return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  event = "BufEnter",
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  -- Everything in opts will be passed to setup()
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      bash = { "shfmt", "shellcheck" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      fish = { "fish_indent" },
      go = { "gofmt" },
      lua = { "stylua" },
      markdown = { "mdformat" },
      python = { "ruff_format" },
      rust = { "rustfmt --edition 2021" },
      sh = { "shfmt", "shellcheck" },
      yaml = { "yamlfmt" },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ["_"] = { "trim_whitespace" },
    },
    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Only autoformat on certain filetypes
      local filetypes = { "rust" }
      if not vim.tbl_contains(filetypes, vim.bo[bufnr].filetype) then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
