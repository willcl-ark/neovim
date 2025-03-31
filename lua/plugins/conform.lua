return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    event = "BufWritePre",
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
    -- This will provide type hinting with LuaLS
    --@module "conform"
    ---@type conform.setupOpts
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
        rust = { "rustfmt" },
        sh = { "shfmt", "shellcheck" },
        yaml = { "yamlfmt" },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- If no other formatter specified:
        ["_"] = { "trim_whitespace" },
      },
      -- Set up format-on-save
      format_on_save = function(bufnr)
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
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
