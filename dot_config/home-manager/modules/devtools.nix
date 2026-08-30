# modules/devtools.nix
# Development tools, languages, and editors
{ pkgs, inputs, ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.uv = {
    enable = true;
    python = {
      versions = [ "3.13" "3.12" ];
      default = "3.13";
    };
    tool.packages = [
      "black"
      "sqlfluff"
    ];
  };

  programs.go = {
    enable = true;
    telemetry.mode = "off";
    env.GOPRIVATE = [
      "github.com/fabrikiot"
      "github.com/ratchio"
    ];
  };

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.pnpm-global/bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # Editor
    neovim

    # Languages
    fnm
    golangci-lint
    pnpm
    rustup

    # Dev
    claude-code
    croc
    # hurl # scripted HTTP test files (.hurl) - no such files in use currently
    graphviz
    jujutsu
    just
    ko
    postgresql
    tectonic
    tilt
    typst
    virtualenv

    # Nix
    deadnix
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    nil
    nixfmt
    nix-tree
    nvd
    statix
  ];
}
