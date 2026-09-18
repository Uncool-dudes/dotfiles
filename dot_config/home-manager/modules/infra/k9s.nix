# modules/k9s.nix
# k9s theme mirrors themes/base16-oxocarbon-dark.yaml (base0X hex below);
# k9s has no stylix target, so this needs manual sync if the scheme changes.
{ ... }:
let
  base00 = "#161616"; # bg
  base02 = "#393939"; # selection/current-line
  base03 = "#525252"; # comment/dim
  base05 = "#f2f4f8"; # fg
  base08 = "#ee5396"; # red
  base09 = "#ff7eb6"; # pink
  base0A = "#ff6f00"; # orange
  base0B = "#42be65"; # green
  base0C = "#3ddbd9"; # cyan
  base0D = "#33b1ff"; # blue
  base0E = "#be95ff"; # purple
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
          buttonFocusFgColor = base0A;
          buttonFocusBgColor = base09;
          labelFgColor = base0A;
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
            highlightColor = base0A;
            killColor = base03;
            completedColor = base03;
          };
          title = {
            fgColor = base05;
            bgColor = base02;
            highlightColor = base0A;
            counterColor = base0E;
            filterColor = base09;
          };
        };
        views = {
          charts = {
            bgColor = "default";
            defaultDialColors = [ base0E base08 ];
            defaultChartColors = [ base0E base08 ];
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
