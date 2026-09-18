# modules/base.nix
# Home-manager glue shared by every host, independent of role. No tool
# config lives here - hosts import this plus whichever roles they want.
{ pkgs, username, ... }: {
  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.05";
    sessionPath = [
      "/nix/var/nix/profiles/default/bin"
      "$HOME/.local/bin"
    ];
  };

  programs.home-manager.enable = true;
  programs.parallel = {
    enable = true;
    will-cite = true;
  };

  programs.nix-index.enable = true;
}
