# modules/devtools.nix
# Development tools, languages, and editors
{ pkgs, inputs, ... }: {
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
    hurl
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
