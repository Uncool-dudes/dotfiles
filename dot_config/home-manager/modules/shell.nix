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
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      WORDCHARS = "";
      SSH_AUTH_SOCK =
        if pkgs.stdenv.isDarwin
        then "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        else "${config.home.homeDirectory}/.1password/agent.sock";
    };
    shellAliases = {
      lz = "lazygit";
      cat = "bat";
      mkdir = "mkdir -p";
      diff = "delta";
      rl = "source ${config.xdg.configHome}/zsh/.zshrc";
      cc = "claude";
      ccc = "claude --continue";
      ccr = "claude --resume";
      cch = "CLAUDE_CONFIG_DIR=~/.claude-home claude";
      ".." = "cd ..";
      "..." = "cd ../..";
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

  home.sessionPath =
    lib.optionals pkgs.stdenv.isDarwin [ "/Applications/1Password.app/Contents/MacOS" ]
    ++ lib.optionals pkgs.stdenv.isLinux [ "/opt/1Password" ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    defaultCommand = "fd --type f --follow";
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
    ];
    fileWidgetCommand = "fd --type f --follow";
    changeDirWidgetCommand = "fd --type d --follow";
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = false;
    silent = true;
  };
}
