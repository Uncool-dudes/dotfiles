{ config, ... }:
{
  programs.navi = {
    enable = true;
    settings = {
      client.tealdeer = true;
      cheats.paths = [ "${config.xdg.configHome}/navi/cheats" ];
      style = {
        tag.color = "#3ddbd9";
        comment.color = "#525252";
        snippet.color = "#42be65";
      };
      finder = {
        command = "fzf";
        overrides = "--height 40%";
      };
    };
  };
}
