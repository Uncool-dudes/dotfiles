# modules/linux.nix
# Hyprland and Linux-only packages
{ pkgs, ... }: {
  home.packages = with pkgs; [
    hyprlauncher
    wireplumber
  ];
}
