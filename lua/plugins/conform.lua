return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    event = "BufEnter",
    dependencies = {
      "williamboman/mason.nvim",
      "zapling/mason-conform.nvim",
    },
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
        rust = { "rustfmt" },
        sh = { "shfmt", "shellcheck" },
        yaml = { "yamlfmt" },
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
    config = function(_, opts)
      -- First set up conform with the options
      require("conform").setup(opts)

      -- Map of formatter names to their executable names
      local formatter_binaries = {
        clang_format = "clang-format",
        fish_indent = "fish_indent",
        gofmt = "gofmt",
        mdformat = "mdformat",
        ruff_format = "ruff",
        rustfmt = "rustfmt",
        shfmt = "shfmt",
        shellcheck = "shellcheck",
        stylua = "stylua",
        yamlfmt = "yamlfmt",
      }

      -- Func to check if a command exists in PATH
      local function command_exists(cmd)
        local handle = io.popen("command -v " .. cmd .. ' >/dev/null 2>&1 && echo "true" || echo "false"')
        if handle then
          local result = handle:read("*l")
          handle:close()
          return result == "true"
        end
        return false
      end

      -- Collect formatters that need to be installed
      local ignore_install = {}
      for formatter, binary in pairs(formatter_binaries) do
        if command_exists(binary) then
          table.insert(ignore_install, formatter)
        else
          vim.notify("Will install " .. formatter .. " via Mason (not found in PATH)", vim.log.levels.INFO)
        end
      end

      -- Set up mason-conform to ignore formatters we already have
      require("mason-conform").setup({
        ignore_install = ignore_install,
      })
    end,
  },
}
