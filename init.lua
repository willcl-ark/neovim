-- Bootstrap Lazy package manager if not installed
require("bootstrap").run()

-- Set keymaps. Must be done early else wrong leader will be used in bindings
require("core.keymaps").setup()

-- Setup plugins using Lazy
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.langs" },
  }
})

require("core.options").setup()

-- Setup Autocommands
require("core.autocommands")
