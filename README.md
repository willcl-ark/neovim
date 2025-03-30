# Neovim config

- 🚀 Blazingly fast
- 💤 Uses [lazy.nvim](https://github.com/folke/lazy.nvim)
- Native LSP and completion from [neovim 11.0](https://neovim.io/doc/user/news-0.11.html)

## Requirements

### General

- Neovim >= 0.11.0
- a [Nerd Font](https://www.nerdfonts.com/) for glyphs (optional)
- a terminal with true colour

The following should be available to Neovim (on `$PATH`) for LSP/telescope to function properly:

- `git`
- [`ripgrep`](https://github.com/BurntSushi/ripgrep)
- [`fd`-find](https://github.com/sharkdp/fd)

Starting `nvim` and running `:checkhealth` should detail what is missing from the config :)

#### C++

- [`clangd`](https://clangd.llvm.org/)
- [`cmake`](https://cmake.org/)

#### Rust

- [`rust_analyzer`](https://rust-analyzer.github.io/manual.html)

#### Python

- [`pyright`](https://github.com/microsoft/pyright)
- [`ruff`](https://github.com/astral-sh/ruff)

#### Go

- [`gopls`](https://pkg.go.dev/golang.org/x/tools/gopls)

#### Zig

- [`zls`](https://github.com/zigtools/zls)

#### Misc

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

- Start `nvim`, wait for installation and first-time-setup to finish and run `:checkhealth`

## Getting started

`:Lazy` will open the package manager.
`q` to quit.

LSPs configurations are found in `lsp/`, and enabled in `lua/lsp.lua`. The various language servers should be installed on your `$PATH` manually for enabled LSPs.
Configurations for other languages can generally be found in the [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file#nvim-lspconfig) repo, and particular settings for a language server in that project's documentation.
run `:help lsp-quickstart` in neovim to see lsp help.

`<space> sk` will open a Telescope search with (most) key bindings.
Filter by `space` (our "leader" key) to see most-useful bindings.
Bindings for unloaded plugins will _not_ be shown (e.g. LSP bindings when an LSP is not attached to the buffer)
`<esc>` to quit.

`<space>aa` will ask Claude about the file. If in visual mode only the visual selection will be sent as context. See avante.nvim for more details.

### C++

You must compile C++ programs using `cmake` (or `Bear`) to generate a compile_commands.json for the clangd language server to use.

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
