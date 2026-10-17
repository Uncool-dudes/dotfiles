{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  c = config.theme.colors;
  base16Attrs =
    {
      scheme = c.scheme;
      author = c.author;
    }
    // lib.mapAttrs (_: v: v.hex) (lib.filterAttrs (n: _: lib.hasPrefix "base" n) c);
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = base16Attrs;

    image =
      pkgs.runCommand "black-pixel"
        {
          nativeBuildInputs = [ pkgs.imagemagick ];
        }
        ''
          convert -size 1x1 xc:'#${c.base00.hex}' $out
        '';

    fonts = {
      monospace = {
        package = pkgs.iosevka;
        name = "Iosevka";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.inter;
        name = "Inter";
      };
    };

    targets = {
      bat.enable = true;
      btop.enable = true;
      fzf.enable = true;
      lazygit.enable = true;
      ghostty.enable = false; # using ghostty's own native Flexoki Dark theme instead
      starship.enable = true;
      yazi.enable = true;
      tmux.enable = true;
    };
  };
}
