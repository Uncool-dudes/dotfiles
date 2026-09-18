{ config, pkgs, ... }: {
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
    env = {
      GOBIN = "${config.home.homeDirectory}/go/bin";
      GOPRIVATE = [
        "github.com/fabrikiot"
        "github.com/ratchio"
      ];
    };
  };

  programs.pnpm = {
    enable = true;
    pnpmHome = "${config.home.homeDirectory}/.pnpm-global";
  };

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    fnm
    golangci-lint
    rustup
    convco
    git-absorb
    lefthook
    ghq
    ast-grep
    just
    tilt
    hl-log-viewer
    procs
    sd
    watchexec
    xh
    hyperfine
    rsync
  ];
}
