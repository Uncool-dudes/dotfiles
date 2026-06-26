{ lib, pkgs, ... }:
let
  settings = {
    font-family = "Iosevka SS08";
    font-size = 19;
    adjust-cell-height = 10;
    theme = "Oxocarbon";

    cursor-style = "bar";
    cursor-click-to-move = true;
    mouse-hide-while-typing = true;

    background-opacity = 0.8;
    background-opacity-cells = true;
    window-padding-x = 30;
    window-padding-y = 30;
    window-padding-balance = true;

    mouse-scroll-multiplier = "precision:0.5,discrete:1";
    scrollback-limit = 50000000;
    copy-on-select = "clipboard";
    mouse-shift-capture = "never";
    confirm-close-surface = true;

    window-inherit-working-directory = true;
    notify-on-command-finish = "unfocused";

    gtk-single-instance = true;
    macos-option-as-alt = true;

    keybind = [
      "ctrl+equal=increase_font_size:1"
      "ctrl+minus=decrease_font_size:1"
      "ctrl+0=reset_font_size"
    ];
  };

  configText = lib.generators.toKeyValue
    { listsAsDuplicateKeys = true; }
    settings;
in
{
  programs.ghostty = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    enableZshIntegration = true;
    inherit settings;
  };

  xdg.configFile."ghostty/config" = lib.mkIf pkgs.stdenv.isDarwin {
    text = configText;
  };
}
