# modules/jq.nix
# Colors mirror themes/base16-oxocarbon-dark.yaml (base0X hex below, as 24-bit
# SGR); jq has no stylix target, so this needs manual sync if the scheme changes.
{ ... }:
{
  programs.jq = {
    enable = true;
    colors = {
      null = "2;38;2;82;82;82"; # base03, dimmed
      false = "0;38;2;238;83;150"; # base08
      true = "0;38;2;66;190;101"; # base0B
      numbers = "0;38;2;255;111;0"; # base0A
      strings = "0;38;2;61;219;217"; # base0C
      arrays = "1;38;2;51;177;255"; # base0D
      objects = "1;38;2;190;149;255"; # base0E
      objectKeys = "1;38;2;130;207;255"; # base0F
    };
  };
}
