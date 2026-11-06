# Fetches every skill source listed in loadout/sources.json. That file is data,
# edited by `loadout add` and `loadout update`, so adding or bumping a source
# never means editing Nix.
{ pkgs }:
builtins.mapAttrs (
  _: entry:
  pkgs.fetchFromGitHub {
    inherit (entry)
      owner
      repo
      rev
      hash
      ;
  }
) (builtins.fromJSON (builtins.readFile ../../loadout/sources.json))
