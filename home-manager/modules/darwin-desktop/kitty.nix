{ pkgs, ... }:
{
  # Fallback for when ghostty breaks; settings and keybinds mirror ghostty.nix.
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;

    font = {
      name = "WumpusMono Nerd Font Mono";
      size = 15;
    };

    # no-cursor: otherwise the shell integration overrides cursor_shape.
    shellIntegration.mode = "no-cursor";

    settings = {
      modify_font = "cell_height 10px";

      cursor_shape = "beam";
      mouse_hide_wait = -1;

      background_opacity = 0.8;
      window_padding_width = 15;
      placement_strategy = "center";
      inactive_text_alpha = 0.7;

      touch_scroll_multiplier = 0.5;
      wheel_scroll_multiplier = 1;
      scrollback_lines = 100000;
      copy_on_select = "clipboard";
      # -1 skips the prompt when every window is idle at a shell prompt.
      confirm_os_window_close = -1;

      notify_on_cmd_finish = "unfocused";
      # nix store is read-only; version bumps come from flake.lock
      update_check_interval = 0;

      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
      macos_option_as_alt = true;
      focus_follows_mouse = true;
      enabled_layouts = "splits,stack";

      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_max_length = 30;
      # kitty parses this as a quoted python string, so the quotes are required.
      tab_title_template = ''"{bell_symbol}{activity_symbol}{index} {title}"'';
      tab_bar_background = "#161616";
      active_tab_background = "#00b4ff";
      active_tab_foreground = "#161616";
      active_tab_font_style = "bold";
      inactive_tab_background = "#393939";
      inactive_tab_foreground = "#f2f4f8";
      inactive_tab_font_style = "normal";

      # xterm-kitty has no terminfo on most remotes, and unlike ghostty's
      # ssh-terminfo nothing installs it for plain ssh.
      term = "xterm-256color";

      # Oxocarbon, copied from ghostty's bundled theme; kitty-themes lacks it.
      foreground = "#f2f4f8";
      background = "#161616";
      cursor = "#ffffff";
      cursor_text_color = "#000000";
      selection_foreground = "#626262";
      selection_background = "#393939";
      color0 = "#161616";
      color1 = "#00dfdb";
      color2 = "#00b4ff";
      color3 = "#ff4297";
      color4 = "#00c15a";
      color5 = "#c693ff";
      color6 = "#ff74b8";
      color7 = "#f2f4f8";
      color8 = "#585858";
      color9 = "#00dfdb";
      color10 = "#00b4ff";
      color11 = "#ff4297";
      color12 = "#00c15a";
      color13 = "#c693ff";
      color14 = "#ff74b8";
      color15 = "#f2f4f8";
    };

    keybindings = {
      "ctrl+equal" = "change_font_size all +1";
      "ctrl+minus" = "change_font_size all -1";
      "ctrl+0" = "change_font_size all 0";

      "cmd+n" = "new_os_window_with_cwd";
      "cmd+t" = "new_tab_with_cwd";

      "cmd+alt+v" = "launch --location=vsplit --cwd=current";
      "cmd+alt+shift+v" = "combine : launch --location=vsplit --cwd=current : move_window left";
      "cmd+alt+s" = "launch --location=hsplit --cwd=current";
      "cmd+alt+shift+s" = "combine : launch --location=hsplit --cwd=current : move_window up";
      "cmd+alt+h" = "neighboring_window left";
      "cmd+alt+l" = "neighboring_window right";
      "cmd+alt+k" = "neighboring_window up";
      "cmd+alt+j" = "neighboring_window down";
      "cmd+alt+z" = "toggle_layout stack";
    };
  };
}
