{ config, pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    deadnix
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    nil
    nixfmt
    nvd
  ];

  programs.nh = {
    enable = true;
    darwinFlake = "${config.home.homeDirectory}/.config/home-manager";
    homeFlake = "${config.home.homeDirectory}/.config/home-manager";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = [ "--keep" "5" "--keep-since" "14d" ];
    };
  };
}
