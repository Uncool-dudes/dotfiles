# Colors are driven by [[theme.active]] (modules/core/theme.nix); jq has no
# stylix target, so SGR codes are built from config.theme.colors.baseXX.rgb.
{ config, ... }:
let
  c = config.theme.colors;
  sgr = attrs: k: "${attrs}38;2;${toString c.${k}.rgb.r};${toString c.${k}.rgb.g};${toString c.${k}.rgb.b}";
in
{
  programs.jq = {
    enable = true;
    colors = {
      null = sgr "2;" "base03"; # dimmed
      false = sgr "0;" "base08";
      true = sgr "0;" "base0B";
      numbers = sgr "0;" "base09";
      strings = sgr "0;" "base0C";
      arrays = sgr "1;" "base0D";
      objects = sgr "1;" "base0E";
      objectKeys = sgr "1;" "base0F";
    };
  };
}
