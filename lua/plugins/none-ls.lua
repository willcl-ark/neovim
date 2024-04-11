return {
	{
		-- Extra code_actions and diagnostics
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("null-ls").register(require("none-ls-shellcheck.diagnostics"))
			require("null-ls").register(require("none-ls-shellcheck.code_actions"))
			local null_ls = require("null-ls")
			local sources = {
				null_ls.builtins.code_actions.gitsigns,
				null_ls.builtins.diagnostics.gitlint,
			}

			null_ls.setup({
				debug = false,
				sources = sources,
			})
		end,
		dependencies = {
			"gbprod/none-ls-shellcheck.nvim",
		},
	},
}
