return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000, -- needs to be loaded in first
  config = function()
    -- Disable virtual text
    vim.diagnostic.config({ virtual_text = false })
    require("tiny-inline-diagnostic").setup({
    preset = "classic",
      options = {
        -- Show the source of the diagnostic.
        show_source = true,

        -- Enable diagnostic message on all lines.
        multilines = false,

        -- Show all diagnostics on the cursor line.
        show_all_diags_on_cursorline = false,
      },
    })
  end,
}
