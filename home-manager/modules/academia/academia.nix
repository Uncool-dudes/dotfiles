{ pkgs, ... }: {
  home.packages = with pkgs; [
    pandoc
    tectonic
    typst
  ];
}
