return {

  -- Extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          src = {
            cmp = { enabled = true },
          },
        },
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },

  -- Add Rust & related to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
      end
    end,
  },

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
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
}
