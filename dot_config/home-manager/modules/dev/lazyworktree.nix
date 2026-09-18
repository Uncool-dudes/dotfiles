# modules/lazyworktree.nix
{ ... }:
{
  programs.lazyworktree = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      sort_mode = "switched";
      auto_refresh = true;
      icon_set = "nerd-font-v3";
    };
  };
}
