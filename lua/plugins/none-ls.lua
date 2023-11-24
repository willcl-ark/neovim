return {
  {
    -- Extra code_actions and diagnostics
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      local sources = {
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.ruff.with({
          extra_args = {
            "--ignore E501", -- ignore line-too-long
            -- "--line-length 88",  -- same as black
          },
        }),
      }

      null_ls.setup({
        debug = false,
        sources = sources,
      })
    end,
  },
}
