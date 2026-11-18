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
        "github.com/apaag-solutions-lab"
        "github.com/fabrikiot"
        "github.com/ratchio"
      ];
      GOCACHE = "${config.xdg.cacheHome}/go-build";
      GOMODCACHE = "${config.xdg.cacheHome}/go-mod";
      # Without it the package dir is part of the build cache key, so every
      # git worktree of a repo compiles into its own copy of the cache.
      GOFLAGS = "-trimpath";
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

  # sccache keys compiled crates by their inputs, so each worktree of a Rust repo reuses
  # dependencies another one already built instead of compiling them again.
  home.sessionVariables = {
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
    SCCACHE_DIR = "${config.xdg.cacheHome}/sccache";
    SCCACHE_CACHE_SIZE = "30G";
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
    sccache
    # nixpkgs' Rust hook forbids vendored libgit2, and convco's git2 wants the
    # SHA-256 build, which plain libgit2 lacks. Drop once nixpkgs adds it.
    (convco.overrideAttrs (o: {
      buildInputs = o.buildInputs ++ [ (libgit2.override { withExperimentalSha256 = true; }) ];
    }))
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
    spicedb
    spicedb-zed
  ];
}
