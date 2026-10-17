{ pkgs, ... }:
let
  # Pinned to the last nixpkgs rev with a cached aarch64-darwin Hydra build
  # for atuin (18.21.0) - tracking nixpkgs-unstable directly rebuilds from
  # source on every version bump since darwin lags linux on Hydra.
  atuinPkgs = import (pkgs.fetchzip {
    url = "https://github.com/NixOS/nixpkgs/archive/6c6973cdf55fbe86579846439ec5ddd9a1198e46.tar.gz";
    hash = "sha256-1IdgiLnf3wkTshSSnjUOPY9HMWG0gZsf/EuuufwMUrE=";
  }) { system = pkgs.stdenv.hostPlatform.system; };
in
{
  programs.atuin = {
    enable = true;
    package = atuinPkgs.atuin;
    enableZshIntegration = false;
    daemon.enable = true;
    settings = {
      search_mode = "fuzzy";
      filter_mode = "global";
      update_check = false;
      workspaces = true;
      style = "compact";
      enter_accept = true;
      show_help = false;
      show_tabs = false;
      show_preview = true;
      max_preview_height = 4;
      secrets_filter = true;

      history_filter = [
        "^export "
        "^set "
        "^source "
        "postgres(ql)?://[^ ]*:[^ ]*@"
      ];

      stats = {
        common_subcommands = [
          "cargo"
          "docker"
          "git"
          "go"
          "kubectl"
          "npm"
          "pnpm"
          "systemctl"
        ];
        common_prefix = [ "sudo" ];
        ignored_commands = [
          "cd"
          "ls"
          "ll"
          "clear"
          "exit"
        ];
      };

      sync_address = "https://atuin.ananthp.dev";
      sync.records = true;
      ui.columns = [
        "time"
        "command"
      ];
    };
  };

  launchd.agents.atuin-daemon.config = {
    StandardOutPath = "/tmp/atuin-daemon.log";
    StandardErrorPath = "/tmp/atuin-daemon.err";
  };

  launchd.agents.atuin-prune-failed = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "$HOME/.nix-profile/bin/atuin search --exclude-exit 0 --before '7 days ago' --delete ''"
      ];
      StartCalendarInterval = [
        {
          Hour = 3;
          Minute = 0;
        }
      ];
      RunAtLoad = false;
      StandardOutPath = "/tmp/atuin-prune-failed.log";
      StandardErrorPath = "/tmp/atuin-prune-failed.err";
    };
  };
}
