return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "super-tab",
      ["<C-k>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-j>"] = { "select_next", "fallback_to_mappings" },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      documentation = { auto_show = false },
      list = { selection = { preselect = false, auto_insert = false } },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "omni", "lazydev", "cmdline" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
    -- Show function signatures; experimental
    signature = { enabled = true }
  },
  opts_extend = { "sources.default" },
}
