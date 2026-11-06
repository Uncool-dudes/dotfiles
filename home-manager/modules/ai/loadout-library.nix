# The loadout skill library: every source in loadout/sources.json laid out as
# one directory per source. `path` points at the directory inside the
# repository that holds the skills, so loadout never scans unrelated trees;
# `include` copies named files or directories instead; `library = false` skips
# a source that is only fetched for a plugin.
{ lib, pkgs }:
let
  entries = builtins.fromJSON (builtins.readFile ../../loadout/sources.json);
  sources = import ./skill-sources.nix { inherit pkgs; };

  place =
    name: entry:
    let
      src = sources.${name};
    in
    if entry ? include then
      ''
        mkdir -p $out/${lib.escapeShellArg name}
        ${lib.concatMapStrings (p: ''
          cp -r --no-preserve=mode ${lib.escapeShellArg "${src}/${p}"} $out/${lib.escapeShellArg name}/
        '') entry.include}
      ''
    else
      ''
        ln -s ${lib.escapeShellArg "${src}${lib.optionalString (entry ? path) "/${entry.path}"}"} $out/${lib.escapeShellArg name}
      '';
in
pkgs.runCommand "loadout-library" { } ''
  mkdir -p $out
  ${lib.concatStrings (
    lib.mapAttrsToList place (lib.filterAttrs (_: entry: entry.library or true) entries)
  )}
''
