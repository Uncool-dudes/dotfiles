{ pkgs, ... }: {
  home.packages = with pkgs; [
    nix-tree
    statix
    hjson-go
  ];
}
