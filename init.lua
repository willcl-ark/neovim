-- Bootstrap Lazy package manager if not installed
require("bootstrap").run()

-- Set keymaps. Must be done early else wrong leader will be used in bindings
require("core.keymaps").setup()

-- LSP config
require("lsp")

-- Setup plugins using Lazy
require("lazy").setup("plugins")

require("core.options").setup()

-- Setup Autocommands
require("core.autocommands")
