return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    opts = {
      -- Define linters_by_ft in the config function since it needs require()
      -- which shouldn't be in the opts table
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        cpp = { "clangtidy" },
        fish = { "fish" },
        go = { "codespell", "golangcilint" },
        html = { "tidy" },
        javascript = { "eslint_d" },
        json = { "jsonlint" },
        lua = { "luacheck" },
        make = { "checkmake" },
        rust = { "clippy" },
        sh = { "shellcheck" },
      }

      -- Checkmake config
      lint.linters.checkmake.args = {
        "--format='{{.LineNumber}}:{{.Rule}}:{{.Violation}}\n'",
        "--config",
        os.getenv("HOME") .. "/.config/checkmake.ini",
      }

      -- Luacheck config
      lint.linters.luacheck = {
        name = "luacheck",
        cmd = "luacheck",
        stdin = true,
        args = {
          "--globals",
          "vim",
          "lvim",
          "reload",
          "--",
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
          source = "luacheck",
        }),
      }

      -- Setup autocmds
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("Linting", { clear = true }),
        callback = function(ev)
          if
            (string.find(ev.file, ".github/workflows/") or string.find(ev.file, ".github/actions/"))
            and vim.bo.filetype == "yaml"
          then
            lint.try_lint("actionlint")
          elseif vim.bo.filetype == "yaml" then
            lint.try_lint("yamllint")
          else
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
