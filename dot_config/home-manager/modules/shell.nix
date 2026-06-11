# modules/shell.nix
# Shell environment — zsh and all shell-integrated tools
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    antidote = {
      enable = true;
      plugins = [
        "romkatv/zsh-defer"
        "zsh-users/zsh-completions kind:fpath"
        "ohmyzsh/ohmyzsh path:lib/key-bindings.zsh"
        "zsh-users/zsh-autosuggestions kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/sudo/sudo.plugin.zsh kind:defer"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
      ];
    };
    setOptions = [
      "CORRECT"
      "GLOB_DOTS"
      "NO_CASE_GLOB"
      "PIPE_FAIL"
      "INTERACTIVE_COMMENTS"
    ];
    completionInit = ''
      autoload -Uz compinit
      setopt EXTENDED_GLOB
      if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
        compinit
      else
        compinit -C
      fi
      unsetopt EXTENDED_GLOB
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    '';
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LG_CONFIG_FILE = "$HOME/.config/lazygit/config.yml";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      WORDCHARS = "";
    };
    shellAliases = {
      lz = "lazygit";
      cat = "bat";
      mkdir = "mkdir -p";
      ls = "eza";
      ll = "eza --icons --git";
      lt = "eza --icons --git --tree";
      diff = "delta";
      cc = "claude";
      ccc = "claude --continue";
      ccr = "claude --resume";
      cch = "CLAUDE_CONFIG_DIR=~/.claude-home claude";
      ".." = "cd ..";
      "..." = "cd ../..";
      # Systemctl (Arch)
      sc-start = "sudo systemctl start";
      sc-stop = "sudo systemctl stop";
      sc-reload = "sudo systemctl reload";
      sc-restart = "sudo systemctl restart";
      sc-try-restart = "sudo systemctl try-restart";
      sc-enable = "sudo systemctl enable";
      sc-disable = "sudo systemctl disable";
      sc-reenable = "sudo systemctl reenable";
    };
    shellGlobalAliases = {
      G = "| rg";
      L = "| less";
      H = "| head";
      T = "| tail";
      C = "| wc -l";
      J = "| jq .";
      S = "| sort";
      U = "| sort -u";
      F = "| fzf";
      NE = "2>/dev/null";
      NUL = ">/dev/null 2>&1";
    };
    initContent = builtins.readFile ./zsh/extra.zsh;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
  };
  programs.atuin = {
    enable = true;
    enableZshIntegration = false;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = false;
  };
}
