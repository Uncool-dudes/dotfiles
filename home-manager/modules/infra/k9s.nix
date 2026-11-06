# modules/k9s.nix
# Colors are driven by [[theme.active]] (modules/core/theme.nix); k9s has no
# stylix target, so this reads config.theme.colors instead of a hardcoded
# palette.
{ config, ... }:
let
  c = config.theme.colors;
  hex = k: "#${c.${k}.hex}";
  base00 = hex "base00"; # bg
  base02 = hex "base02"; # selection/current-line
  base03 = hex "base03"; # comment/dim
  base05 = hex "base05"; # fg
  base08 = hex "base08"; # red
  base09 = hex "base09"; # orange
  base0B = hex "base0B"; # green
  base0C = hex "base0C"; # cyan
  base0D = hex "base0D"; # blue
  base0E = hex "base0E"; # purple
in
{
  programs.k9s = {
    enable = true;

    settings.k9s.refreshRate = 2;

    skins.oxocarbon-dark = {
      k9s = {
        body = {
          fgColor = base05;
          bgColor = base00;
          logoColor = base0E;
        };
        prompt = {
          fgColor = base05;
          bgColor = base00;
          suggestColor = base0E;
        };
        info = {
          fgColor = base09;
          sectionColor = base05;
        };
        dialog = {
          fgColor = base05;
          bgColor = base00;
          buttonFgColor = base05;
          buttonBgColor = base0E;
          buttonFocusFgColor = base09;
          buttonFocusBgColor = base09;
          labelFgColor = base09;
          fieldFgColor = base05;
        };
        frame = {
          border = {
            fgColor = base02;
            focusColor = base02;
          };
          menu = {
            fgColor = base05;
            keyColor = base09;
            numKeyColor = base09;
          };
          crumbs = {
            fgColor = base05;
            bgColor = base02;
            activeColor = base02;
          };
          status = {
            newColor = base0C;
            modifyColor = base0E;
            addColor = base0B;
            errorColor = base08;
            highlightColor = base09;
            killColor = base03;
            completedColor = base03;
          };
          title = {
            fgColor = base05;
            bgColor = base02;
            highlightColor = base09;
            counterColor = base0E;
            filterColor = base09;
          };
        };
        views = {
          charts = {
            bgColor = "default";
            defaultDialColors = [
              base0E
              base08
            ];
            defaultChartColors = [
              base0E
              base08
            ];
          };
          table = {
            fgColor = base05;
            bgColor = base00;
            header = {
              fgColor = base05;
              bgColor = base00;
              sorterColor = base0C;
            };
          };
          xray = {
            fgColor = base05;
            bgColor = base00;
            cursorColor = base02;
            graphicColor = base0E;
            showIcons = false;
          };
          yaml = {
            keyColor = base09;
            colonColor = base0E;
            valueColor = base05;
          };
          logs = {
            fgColor = base05;
            bgColor = base00;
            indicator = {
              fgColor = base05;
              bgColor = base0E;
              toggleOnColor = base0B;
              toggleOffColor = base0C;
            };
          };
        };
      };
    };
  };
}
