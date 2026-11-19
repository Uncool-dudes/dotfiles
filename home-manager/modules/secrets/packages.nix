{ lib, pkgs, ... }: {
  # Darwin gets `op` from the 1password-cli cask instead: Alfred's 1Password
  # workflow runs `env op`, and Alfred's script PATH covers /opt/homebrew/bin
  # but not ~/.nix-profile/bin.
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs._1password-cli
  ];
}
