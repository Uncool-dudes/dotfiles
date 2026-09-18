# modules/worktrunk.nix
{ ... }:
{
  programs.worktrunk = {
    enable = true;
    enableZshIntegration = false;
  };
}
