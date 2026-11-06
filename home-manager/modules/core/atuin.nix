{ inputs, pkgs, ... }:
{
  programs.atuin = {
    enable = true;
    # atuin's own flake tracks its releases directly, with a cached
    # aarch64-darwin build on numtide's cache - no nixpkgs-bump lag to pin
    # around, unlike the old nixpkgs-rev pin this replaced.
    package = inputs.atuin.packages.${pkgs.stdenv.hostPlatform.system}.atuin;
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
