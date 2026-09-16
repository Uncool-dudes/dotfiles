{ ... }:
{
  programs.tealdeer = {
    enable = true;
    settings = {
      display.use_pager = true;
      updates.auto_update = true;
      # Colors mirror themes/base16-oxocarbon-dark.yaml (base0X noted below);
      # tealdeer has no stylix target, so this needs manual sync if the scheme changes.
      style = {
        description.foreground.rgb = { r = 242; g = 244; b = 248; }; # base05
        command_name = {
          foreground.rgb = { r = 51; g = 177; b = 255; }; # base0D
          bold = true;
        };
        example_text.foreground.rgb = { r = 82; g = 82; b = 82; }; # base03
        example_code.foreground.rgb = { r = 66; g = 190; b = 101; }; # base0B
        example_variable = {
          foreground.rgb = { r = 255; g = 111; b = 0; }; # base0A
          italic = true;
        };
      };
    };
  };
}
