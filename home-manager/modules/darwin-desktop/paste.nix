{ lib, ... }:
let
  # Caps Lock is Hyper (cmd+ctrl+opt+shift) via karabiner/karabiner.json; no
  # app binds all four modifiers, so Hyper combos never collide.
  hyper = 1966080;

  # Paste stores each hotkey as a JSON blob in a data-typed default, which
  # system.defaults/CustomUserPreferences can't express, hence `defaults write
  # -data` here. keyCode is the macOS virtual key code (9 = V, 8 = C).
  shortcuts = {
    activationShortcut = {
      keyCode = 9;
      internalModifiers = hyper;
    };
    pasteStackShortcut = {
      keyCode = 8;
      internalModifiers = hyper;
    };
  };

  writeShortcut = name: value: ''
    run /usr/bin/defaults write com.wiheads.paste-direct ${name} -data \
      "$(printf '%s' ${lib.escapeShellArg (builtins.toJSON value)} | /usr/bin/xxd -p | tr -d '\n')"
  '';
in
{
  # Paste reads these at launch; restart it after the first switch.
  home.activation.pasteShortcuts = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStrings (lib.mapAttrsToList writeShortcut shortcuts)
  );
}
