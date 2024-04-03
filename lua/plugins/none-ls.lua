return {
  {
    -- Extra code_actions and diagnostics
    "nvimtools/none-ls.nvim",
    dependencies = {
      "gbprod/none-ls-shellcheck.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      local sources = {
        require("none-ls-shellcheck.diagnostics"),
        require("none-ls-shellcheck.code_actions"),
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.gitlint,
      }

      null_ls.setup({
        debug = false,
        sources = sources,
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "gbprod/none-ls-shellcheck.nvim",
    },
  },
}
