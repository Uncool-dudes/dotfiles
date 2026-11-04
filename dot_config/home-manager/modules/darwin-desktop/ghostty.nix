{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    # Pinned to 1.3.1: 1.4.0 broken. Drop override once a fixed release lands.
    package = pkgs.ghostty-bin.overrideAttrs (
      finalAttrs: _: {
        version = "1.3.1";
        src = pkgs.fetchurl {
          url = "https://release.files.ghostty.org/${finalAttrs.version}/Ghostty.dmg";
          hash = "sha256-GM/ysKbO6Q7q2cfTBk6AiiUqQLryFKp1LB7LeTuPX2k=";
        };
      }
    );
    enableZshIntegration = pkgs.stdenv.hostPlatform.isLinux;

    settings = {
      # using ghostty's bundled native theme directly instead of stylix's
      # generated one (disabled in modules/core/stylix.nix); theme.nix's
      # flexoki-dark scheme is kept in sync with this for every other app.
      theme = "Oxocarbon";

      font-family = "WumpusMono Nerd Font Mono";
      font-size = 15;
      adjust-cell-height = 10;
      font-thicken = true;

      cursor-style = "bar";
      cursor-click-to-move = true;
      mouse-hide-while-typing = true;

      background-opacity = 0.8;
      background-opacity-cells = true;
      window-padding-x = 15;
      window-padding-y = 15;
      window-padding-balance = true;
      macos-titlebar-style = "native";

      mouse-scroll-multiplier = "precision:0.5,discrete:1";
      scrollback-limit = 50000000;
      copy-on-select = "clipboard";
      mouse-shift-capture = "never";
      confirm-close-surface = true;

      window-inherit-working-directory = true;
      notify-on-command-finish = "unfocused";
      window-save-state = "never";
      # nix store is read-only; version bumps come from flake.lock
      auto-update = "off";

      quick-terminal-position = "bottom";
      quick-terminal-size = "35%";

      shell-integration-features = "sudo,ssh-env,ssh-terminfo";

      macos-auto-secure-input = true;
      clipboard-paste-protection = true;
      clipboard-read = "allow";

      gtk-single-instance = true;
      macos-option-as-alt = true;

      unfocused-split-opacity = 0.7;
      focus-follows-mouse = true;

      keybind = [
        "ctrl+equal=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+0=reset_font_size"

        "global:cmd+shift+grave_accent=toggle_quick_terminal"

        "cmd+alt+v=new_split:right"
        "cmd+alt+shift+v=new_split:left"
        "cmd+alt+s=new_split:down"
        "cmd+alt+shift+s=new_split:up"
        "cmd+alt+h=goto_split:left"
        "cmd+alt+l=goto_split:right"
        "cmd+alt+k=goto_split:up"
        "cmd+alt+j=goto_split:down"
        "cmd+alt+z=toggle_split_zoom"
      ];
    };
  };
}
