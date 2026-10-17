{ pkgs, ... }:
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
    plugins = with pkgs.tmuxPlugins; [
      tmux-thumbs
      fzf-tmux-url
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -as terminal-overrides ",*:Tc"
      set -g set-clipboard on

      set -g display-time 4000
      set -g display-panes-time 1000
      set -g repeat-time 600
      set -gu update-environment

      set -g status-interval 5
      set -g status-left-length 20
      set -g status-right-length 20

      set -g pane-border-status off

      set -g status-left " #S "
      set -g status-right ""
      set -g window-status-current-format " #I "
      set -g window-status-format " #I "

      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."
      bind-key "s" run-shell "sesh connect \"$(
        sesh list --icons | fzf --popup 70%,42% \
          --border rounded \
          --no-sort --ansi --no-separator --padding 0 --margin 0 \
          --prompt "" --pointer "" --marker "" --highlight-line \
          --info inline \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:reload(sesh list --icons)' \
          --bind 'ctrl-t:reload(sesh list -t --icons)' \
          --bind 'ctrl-g:reload(sesh list -c --icons)' \
          --bind 'ctrl-x:reload(sesh list -z --icons)' \
          --bind 'ctrl-f:reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+reload(sesh list --icons)' \
          --preview-window 'right:55%,border-rounded,follow' \
          --preview 'sesh preview {}'
      )\""
      bind-key "S" run-shell "sesh last"
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
