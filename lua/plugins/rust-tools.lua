return {
  {
    "simrat39/rust-tools.nvim",
    -- only load this plugin for rust files
    event = { "BufReadPre *.rs", "BufNewFile *.rs" },
    opts = function()
      local rt = require("rust-tools")

      return {
        tools = {
          -- Disable inlay hints since Neovim now supports them.
          inlay_hints = {
            auto = false,
            show_parameter_hints = false,
          },
          hover_actions = {
            max_height = 20,
            max_width = 120,
          },
        },
        server = {
          capabilities = require("lsp").client_capabilities(),
          cmd = { "rust-analyzer" },
          on_attach = function(_, bufnr)
            -- Add some extra rust-specific keymaps.
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, {
              buffer = bufnr,
              desc = "Hover",
            })
            local function keymap(key, rhs, desc)
              vim.keymap.set("n", "<leader>c" .. key, rhs, { desc = desc, buffer = bufnr })
            end
            keymap("c", rt.open_cargo_toml.open_cargo_toml, "Open Cargo.toml")
            keymap("m", rt.expand_macro.expand_macro, "Expand macro")
            keymap("R", rt.runnables.runnables, "Runnables")
          end,
          settings = {
            ["rust-analyzer"] = {
              inlayHints = {
                -- These are a bit too much.
                chainingHints = { enable = false },
              },
            },
          },
        },
      }
    end,
  },
}
