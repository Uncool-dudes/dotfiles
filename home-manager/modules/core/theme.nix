# Single source of truth for color theming. Swap schemes by changing
# `theme.active` (see themes/schemes/*.nix for available scheme names and to
# add new ones). Consumers that stylix can't target directly (k9s, eza, jq,
# tealdeer - no stylix module for them) read `config.theme.colors.baseXX.hex`
# / `.rgb` instead of hardcoding hex.
{ lib, config, ... }:
let
  schemes = {
    oxocarbon-dark = import ../../themes/schemes/oxocarbon-dark.nix;
    flexoki-dark = import ../../themes/schemes/flexoki-dark.nix;
  };
in
{
  options.theme = {
    active = lib.mkOption {
      type = lib.types.enum (lib.attrNames schemes);
      default = "oxocarbon-dark";
      description = "Active base16 color scheme (key into themes/schemes/).";
    };

    colors = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      internal = true;
      description = "Resolved base16 palette for theme.active.";
    };
  };

  config.theme.colors = schemes.${config.theme.active};
}
