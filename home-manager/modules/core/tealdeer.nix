# Colors are driven by [[theme.active]] (modules/core/theme.nix); tealdeer
# has no stylix target, so this reads config.theme.colors.baseXX.rgb.
{ config, ... }:
let
  rgb = k: config.theme.colors.${k}.rgb;
in
{
  programs.tealdeer = {
    enable = true;
    settings = {
      display.use_pager = true;
      updates.auto_update = true;
      style = {
        description.foreground.rgb = rgb "base05";
        command_name = {
          foreground.rgb = rgb "base0D";
          bold = true;
        };
        example_text.foreground.rgb = rgb "base03";
        example_code.foreground.rgb = rgb "base0B";
        example_variable = {
          foreground.rgb = rgb "base09";
          italic = true;
        };
      };
    };
  };
}
