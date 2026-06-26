{ ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    baseIndex = 1;
    terminal = "tmux-256color";
    escapeTime = 0;
    historyLimit = 50000;
    focusEvents = true;
    extraConfig = ''
      set -as terminal-overrides ",*:Tc"

      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."
      bind-key L clear-history
      bind-key space next-window
      bind-key bspace previous-window
      bind-key enter next-layout
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
    '';
  };
}
