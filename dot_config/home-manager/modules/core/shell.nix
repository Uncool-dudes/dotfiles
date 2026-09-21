{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.sessionVariables =
    {
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_ENV_HINTS = "1";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      PAGER = "ov";
      GHQ_ROOT = "${config.home.homeDirectory}/projects";
      DISABLE_AUTOUPDATER = "1";
      DO_NOT_TRACK = "1";
      DOCKER_CLI_HINTS = "false";
      PS4 = "+%N:%i> ";
      MAILCHECK = "0";
      BUILDKIT_PROGRESS = "plain";
      COMPOSE_MENU = "false";
      COMPOSE_BAKE = "true";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      BROWSER = "open";
    };

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
      "HIST_VERIFY"
    ];
    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      size = 50000;
      save = 50000;
      ignoreSpace = true;
      ignoreAllDups = true;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
    };
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
      WORK_FOLDER = "${config.home.homeDirectory}/projects/ratch";
      ZSH_AUTOSUGGEST_MANUAL_REBIND = "1";
      WORDCHARS = "";
      NODE_NO_WARNINGS = "1";
    };
    shellAliases = {
      "7z" = "7zz";
      lz = "lazygit";
      ll = "eza -lah --git --icons";
      lt = "eza --tree --level=2 --icons";
      mkdir = "mkdir -p";
      diff = "delta";
      du = "dust";
      df = "duf";
      pg_dump = "pg_dump --no-owner --no-privileges --format=custom --compress=9";
      rsync = "rsync -avP";
      glow = "glow -s dark";
      wget = "wget --hsts-file=/dev/null";
      rl = "source ${config.xdg.configHome}/zsh/.zshrc";
      alloydb-tunnel = "autossh -M 0 -Nf alloydb";
      cc = "claude";
      ccc = "claude --continue";
      ccr = "claude --resume";
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
    lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ "/Applications/1Password.app/Contents/MacOS" ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ "/opt/1Password" ];
}
