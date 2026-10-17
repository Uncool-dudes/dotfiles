{ config, pkgs, ... }: {
  programs.uv = {
    enable = true;
    python = {
      versions = [
        "3.13"
        "3.12"
      ];
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
      GOCACHE = "${config.xdg.cacheHome}/go-build";
      GOMODCACHE = "${config.xdg.cacheHome}/go-mod";
    };
  };

  programs.pnpm = {
    enable = true;
    pnpmHome = "${config.home.homeDirectory}/.pnpm-global";
  };

  launchd.agents.go-clean-cache = {
    enable = true;
    config = {
      ProgramArguments = [
        "/etc/profiles/per-user/${config.home.username}/bin/go"
        "clean"
        "-cache"
      ];
      StartCalendarInterval = [
        {
          Day = 1;
          Hour = 4;
          Minute = 0;
        }
      ];
      RunAtLoad = false;
      StandardOutPath = "/tmp/go-clean-cache.log";
      StandardErrorPath = "/tmp/go-clean-cache.err";
    };
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
    git-branchless
    mergiraf
    lefthook
    ghq
    ast-grep
    just
    tilt
    procs
    sd
    watchexec
    xh
    hyperfine
    rsync
    weaver
  ];
}
