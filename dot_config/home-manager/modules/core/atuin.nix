{ ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = false;
    daemon.enable = true;
    settings = {
      search_mode = "fuzzy";
      filter_mode = "global";
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
}
