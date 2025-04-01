{https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
  description = "Neovim with LSPs and formatters";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            neovim

            # General, Telescope
            git
            ripgrep
            fd

            # LSPs
            # C++
            clang-tools  # Provides clangd and clang-format
            cmake

            # Rust
            rust-analyzer
            rustfmt

            # Python
            basedpyright
            ruff

            # Go
            gopls
            go  # Provides gofmt

            # Zig
            zls

            # Shell(s)
            fish-lsp
            shellcheck
            shfmt

            # Misc
            codespell
            gitlint
            mdformat
            stylua
          ];

          shellHook = ''
            echo "Neovim development environment loaded"
          '';
        };

      }
    );
}
