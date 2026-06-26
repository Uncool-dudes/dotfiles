{ ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = false;
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
          "cargo" "docker" "git" "go"
          "kubectl" "npm" "pnpm"
          "systemctl" "tmux"
        ];
        common_prefix = [ "sudo" ];
        ignored_commands = [ "cd" "ls" "ll" "clear" "exit" ];
      };

      sync.records = true;
      daemon.enabled = true;
      ui.columns = [ "time" "command" ];
    };
  };
}
