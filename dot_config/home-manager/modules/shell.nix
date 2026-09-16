{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_ENV_HINTS = "1";
    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    PAGER = "ov";
    GHQ_ROOT = "${config.home.homeDirectory}/projects";
  };

  # DataGrip/JetBrains SSH client can't parse a socket path containing spaces
  # (IJPL-63098) - symlink the real 1Password socket to a space-free path.
  home.activation.linkOnePasswordAgentSock = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    if pkgs.stdenv.hostPlatform.isDarwin then ''
      mkdir -p "${config.home.homeDirectory}/.1password"
      ln -sf "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
        "${config.home.homeDirectory}/.1password/agent.sock"
    '' else ""
  );

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
      WORK_FOLDER = "${config.home.homeDirectory}/projects/ratch";
      ZSH_AUTOSUGGEST_MANUAL_REBIND = "1";
      WORDCHARS = "";
      NODE_NO_WARNINGS = "1";
    };
    shellAliases = {
      "7z" = "7zz";
      lz = "lazygit";
      mkdir = "mkdir -p";
      diff = "delta";
      du = "dust";
      df = "duf";
      pg_dump = "pg_dump --no-owner --no-privileges --format=custom --compress=9";
      rsync = "rsync -avP";
      rl = "source ${config.xdg.configHome}/zsh/.zshrc";
      cc = "claude";
      ccc = "claude --continue";
      ccr = "claude --resume";
      cch = "CLAUDE_CONFIG_DIR=~/.claude-home claude";
      cql = "codeql query run --search-path ~/.codeql/packages";
      cqldb = "codeql database create --language=go --source-root=. --threads=4";
      cqli = "codeql pack install";
      cqlq = "cd .codeql/queries";
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    defaultCommand = "fd --type f --follow";
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
    ];
    fileWidget.command = "fd --type f --follow";
    changeDirWidget.command = "fd --type d --follow";
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
  };

  launchd.agents.ssh-auth-sock-setenv = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/launchctl"
        "setenv"
        "SSH_AUTH_SOCK"
        config.home.sessionVariables.SSH_AUTH_SOCK
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
