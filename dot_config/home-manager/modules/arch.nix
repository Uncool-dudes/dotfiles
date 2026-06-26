# modules/arch.nix
# Arch Linux / Hyprland-specific packages
{ pkgs, ... }: {
  home.packages = with pkgs; [
    hyprlauncher
    qview
    wireplumber
  ];
}
