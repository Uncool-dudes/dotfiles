{ pkgs, ... }: {
  home.packages = with pkgs; [
    abtop
  ];
}
