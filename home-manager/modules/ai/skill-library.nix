# Wires loadout into the home: the package, the skill library built from
# loadout/sources.json, the profile file, and a global sync on every switch.
# Nothing here links skills into ~/.claude directly; `loadout sync` picks them
# from the library, globally and per project, driven by loadout/loadout.hjson.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  loadout = inputs.loadout.packages.${pkgs.stdenv.hostPlatform.system}.default;
  library = import ./loadout-library.nix { inherit lib pkgs; };
in
{
  home.packages = [ loadout ];

  xdg.dataFile."loadout/library".source = library;

  # Out-of-store link, so profiles can be edited in the repo and take effect
  # without a rebuild. sources.json sits next to it, which is how `loadout add`
  # finds the file to edit.
  xdg.configFile."loadout/loadout.hjson".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/loadout/loadout.hjson";

  # Global skills are loadout's job, so a switch finishes by syncing them. The
  # package's own path is used because the new profile is not on PATH yet while
  # activation runs. A failed sync does not fail the switch.
  home.activation.loadoutSyncGlobal = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${loadout}/bin/loadout sync --global || echo "loadout: global sync failed, run 'loadout sync --global' by hand" >&2
  '';
}
