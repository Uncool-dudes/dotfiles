{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      command_timeout = 1000;
      scan_timeout = 500;
      format = "$directory$git_branch$git_status$nix_shell$direnv$cmd_duration$character";
      palette = "oxocarbon";

      palettes.oxocarbon = {
        blue   = "#78a9ff";
        cyan   = "#33b1ff";
        green  = "#42be65";
        pink   = "#ff7eb6";
        red    = "#ee5396";
        purple = "#be95ff";
        teal   = "#08bdba";
        muted  = "#525252";
      };

      directory = {
        format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style) ";
        style = "bold fg:blue";
        repo_root_style = "bold fg:blue";
        before_repo_root_style = "fg:muted";
        truncation_length = 10;
        truncate_to_repo = false;
        home_symbol = "~";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold fg:red";
        truncation_length = 24;
        truncation_symbol = "…";
      };

      git_status = {
        format = "([$conflicted]($style) )";
        style = "bold fg:pink";
        conflicted = "~";
      };

      direnv = {
        disabled = false;
        format = "[$symbol](fg:muted)[$allowed]($style) ";
        symbol = "⚿ ";
        style = "bold fg:teal";
        allowed_msg = "✓";
        denied_msg = "✗";
        not_allowed_msg = "?";
      };

      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "❄ ";
        style = "bold fg:cyan";
        pure_msg = "✓";
        impure_msg = "✗";
        unknown_msg = "?";
        heuristic = true;
      };

      fill.symbol = " ";

      cmd_duration = {
        format = "[ $duration]($style) ";
        style = "bold fg:green";
        min_time = 2000;
        show_milliseconds = false;
      };

      status.disabled = true;

      character = {
        success_symbol = "[❯](bold fg:blue)";
        error_symbol   = "[❯](bold fg:red)";
        vimcmd_symbol  = "[❮](bold fg:purple)";
      };
    };
  };
}
