# Neovim config

- 🚀 Blazingly fast
- 💤 Uses [lazy.nvim](https://github.com/folke/lazy.nvim)

## Requirements

### General

The following should be available to Neovim (on `$PATH`) for LSP/telescope to function properly:

- Neovim >= 0.8.0
- a [Nerd Font](https://www.nerdfonts.com/) for glyphs (optional)
- a terminal with true colour (kitty, alacritty, iTerm2 etc.)
- `git`
- [`ripgrep`](https://github.com/BurntSushi/ripgrep)
- [`fd`-find](https://github.com/sharkdp/fd)

There are some language-specific tools which are searched for on `$PATH` and installed automatically  by mason-lspconfig if they are not found there.
Tools can be installed directly via Mason (with `:Mason`), but it's generally preferable to use a tool found on `$PATH` as then the tool will directly match versions with what the user will use in the terminal.

Starting `nvim` and running `:checkhealth` will detail what is missing.

### C++

- [`clangd`](https://clangd.llvm.org/)
- [`cmake`](https://cmake.org/)
- [`Bear`](https://github.com/rizsotto/Bear) (optional but required for C++ LSP if not using `cmake` to output a `compile_commands.json` file)

### Rust

- [`rust_analyzer`](https://rust-analyzer.github.io/manual.html)

### Python

- [`pyright`](https://github.com/microsoft/pyright)
- [`ruff`](https://github.com/astral-sh/ruff)
- [`yapf`](https://github.com/google/yapf) (optional)

### Go

- [`gopls`](https://pkg.go.dev/golang.org/x/tools/gopls)

### Zig

- [`zls`](https://github.com/zigtools/zls)

### Misc

- [`shellcheck`](https://www.shellcheck.net/)
- [`shfmt`](https://github.com/mvdan/sh)
- [`gitlint`](https://jorisroovers.com/gitlint/latest/)
- [`stylua`](https://github.com/JohnnyMorganz/StyLua)

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

- (optional) remove the .git folder, so you can add it to your own repo later:

```bash
rm -rf ~/.config/nvim/.git
```

- (Optional, recommended) set up dedicated python venv(s) for neovim:
  - python3 venv and install `pynvim` package
  - python2 venv and install `pynvim` package [optional]

- Export env vars `NVIM_PYTHON3` and optionally `NVIM_PYTHON` to point to the python environment(s) for neovim, e.g.:

e.g.:

```fish
# fish shell syntax
set -gx NVIM_PYTHON $HOME/.pyenv/versions/neovim2/bin/python
set -gx NVIM_PYTHON3 $HOME/.pyenv/versions/neovim3/bin/python
```

- Start `nvim`, wait for installation and first-time-setup to finish and run `:checkhealth`

## Getting started

`:Lazy` will open the package manager.
`q` to quit.

`:Mason` will open the LSP server manager which can be used to install LSP servers, DAP, Formatters and Linters from within neovim.
Default config will install LSPs found in `~/.config/nvim/lua/plugins/lsp.lua`, e.g.: `local servers = { "lua_ls" }`, and will look for `clangd`, `rust_analyzer` and others on `$PATH`.
`q` to quit.

`<space> sk` will open a Telescope search with (most) key bindings.
Filter by `space` (our "leader" key) to see most-useful bindings.
Bindings for unloaded plugins will _not_ be shown (e.g. LSP bindings when an LSP is not attached to the buffer)
`<esc>` to quit.

`<space>aa` will ask Claude about the file. If in visual mode only the visual selection will be sent as context. See avante.nvim for more details.

### C++

You must compile C++ programs using `cmake` or `Bear` to generate a compile_commands.json for the clangd LS to use.

### Handy bindings

- Hover over function: `<S-K>` to show signature.
- `<space><space>`                         open current buffer list with fuzzy finder.
- `<space>sf` [S]earch [F]iles             from root with fuzzy finder.
- `<space>sg` [S]earch [G]rep              (strings) from root with fuzzy finder.
- `<space>ss` [S]earch [S]rc               (strings) from root `src` directory with fuzzy finder.
- `<space>sb` [S]earch [B]uffer            search current buffer for string.
- `<space>sd` [S]earch [D]iagnostics       search project diagnostics.
- `<space>sw` [S]earch [W]orkspace symbols search symbols in current workspace.
- `<space>gd` [G]o to  [D]efinition        jump to function definition. `<C-o>` to jump back through the jumplist.
- `<space>gD` [G]o to  [D]eclaration       jump to function definition. `<C-o>` to jump back through the jumplist.
- `<space>gi` [G]o to  [I]mplementation    jump to function implementation. `<C-o>` to jump back through the jumplist.
- `<space>?`                               Recently opened ("oldfiles") file picker.
- `<space>z`                               Zen mode toggle
- `<space>ud`                              Diagnostics toggle
- `<space>uw`                              Word wrap toggle

