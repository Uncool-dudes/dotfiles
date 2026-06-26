# modules/devtools.nix
# Development tools, languages, and editors
{ pkgs, inputs, ... }: {
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.pnpm-global/bin"
  ];

  home.packages = with pkgs; [
    # Editor
    black
    neovim
    sqlfluff

    # Languages
    fnm
    go
    golangci-lint
    pnpm
    rustup
    uv

    # Dev
    claude-code
    croc
    graphviz
    just
    tectonic
    tilt
    typst

    # Nix
    deadnix
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    nil
    nixfmt
    nvd
    statix
  ];
}
