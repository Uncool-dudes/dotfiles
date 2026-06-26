# modules/ubuntu.nix
# Ubuntu-specific packages
{ pkgs, ... }: {
  home.packages = [ pkgs.qview ];
}
