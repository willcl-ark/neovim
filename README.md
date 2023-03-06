# Neovim config

- 🚀 Blazingly fast
- 💤 Uses lazy.nvim

## Requirements

- Neovim >= 0.8.0
- git
- `clangd` on `$PATH`
- `rust_analyzer` on `$PATH`
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- a Nerd Font
- A terminal with true colour (kitty, alacritty, iTerm2 etc.)
- (optional) [Bear](https://github.com/rizsotto/Bear) on `$PATH`

## Setup

- Make a backup of your current Neovim files:

```bash
# required
mv ~/.config/nvim ~/.config/nvim.bak

# optional but recommended
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

- Clone the repo:

```bash
git clone https://github.com/willcl-ark/neovim ~/.config/nvim
```

- (Optional) remove the .git folder, so you can add it to your own repo later:

```bash
rm -rf ~/.config/nvim/.git
```

- (Optional, recommended) set up python venvs for neovim:
  - python3 venv and install `pynvim` package.
  - python2 venv and install `pynvim` package.

- Start `nvim`, wait for installation and first-time-setup to finish and run `:checkhealth`

- Edit the path to your python venv(s) found in file `~/.config/nvim/lua/core/options.lua` by changing the lines:

```bash
    -- Python venv
    vim.g.python_host_prog = os.getenv("HOME") .. "/.pyenv/versions/neovim2/bin/python"
    vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/neovim3/bin/python"
```

## Getting started

`:Lazy` will open the package manager.
`q` to quit.

`:Mason` will open the LSP server manager which can be used to install LSP servers, DAP, Formatters and Linters from within neovim.
Default config will install LSPs found in `~/.config/nvim/lua/plugins/lsp.lua`, e.g.: `local servers = { "pyright", "lua_ls", "gopls", "cmake" }` and will look for `clangd` and `rust_analyzer` on `$PATH`.
`q` to quit.

`<space> sk` will open a Telescope search with (most) key bindings.
Filter by `space` (our "leader" key) to see most-useful bindings.
Bindings for unloaded plugins will _not_ be shown (e.g. LSP bindings when an LSP is not attached to the buffer)
`<esc>` to quit.

### Handy bindings

- Hover over function: `<C-k>` to show signature.
- `<space><space>` open buffer list with fuzzy finder.
- `<space>sf` [S]earch [F]iles from root with fuzzy finder.
- `<space>sg` [S]earch [G]rep (strings) from root with fuzzy finder.
- `<space>sb` [S]earch [B]uffer search current buffer for string.
- `<space>gd` [G]o [D]efinition will jump to function definition. `<C-o>` to jump back through the jumplist.
- `<space>gi` [G]o [I]mplementation will jump to function implementation. `<C-o>` to jump back through the jumplist.
- `<space>?`  Recently opened file picker.

