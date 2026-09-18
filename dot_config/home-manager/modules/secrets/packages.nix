{ pkgs, ... }: {
  home.packages = with pkgs; [
    age
    sops
    _1password-cli
  ];
}
