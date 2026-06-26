{ inputs, pkgs, ... }:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = ../themes/base16-oxocarbon-dark.yaml;

    image = pkgs.runCommand "black-pixel" {
      nativeBuildInputs = [ pkgs.imagemagick ];
    } ''
      convert -size 1x1 xc:'#161616' $out
    '';

    fonts = {
      monospace = { package = pkgs.iosevka; name = "Iosevka"; };
      sansSerif = { package = pkgs.inter; name = "Inter"; };
      serif     = { package = pkgs.inter; name = "Inter"; };
    };

    targets = {
      bat.enable = true;
      btop.enable = true;
      fzf.enable = true;
      mpv.enable = true;
      tmux.enable = true;
    };
  };

}
