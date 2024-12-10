return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                cpp = { "clangtidy" },
                fish = { "shellcheck", "fish" },
                go = { "codespell", "golangcilint" },
                html = { "tidy" },
                javascript = { "eslint_d" },
                json = { "jsonlint" },
                lua = { "luacheck" },
                make = { "checkmake" },
                -- markdown = { "alex", "markdownlint" },
                rust = { "clippy" },
                sh = { "shellcheck" },
            }

            -- Checkmake requires a ini file in the current directory
            -- Otherwise you have to specify a global one
            lint.linters.checkmake.args = {
                "--format='{{.LineNumber}}:{{.Rule}}:{{.Violation}}\n'",
                "--config", os.getenv("HOME") .. "/.config/checkmake.ini",
            }
            -- handle vim gloabls using luacheck
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

            -- NOTE: custom logic for handling YAML linting
            -- to parse out when we are in a github action
            vim.api.nvim_create_autocmd({
                "BufReadPost", "BufWritePost", "InsertLeave"
            }, {
                group = vim.api.nvim_create_augroup("Linting", { clear = true }),
                callback = function(ev)
                    -- print(string.format('event fired: %s', vim.inspect(ev)))
                    -- print(vim.bo.filetype)
                    if (string.find(ev.file, ".github/workflows/") or string.find(ev.file, ".github/actions/")) and vim.bo.filetype == "yaml" then
                        lint.try_lint("actionlint")
                    elseif vim.bo.filetype == "yaml" then
                        lint.try_lint("yamllint")
                    else
                        lint.try_lint()
                    end
                end
            })
        end
    }
}
