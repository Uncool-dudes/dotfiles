{ ... }:
{
  imports = [
    ../darwin-desktop/ghostty.nix
    ../darwin-desktop/kitty.nix
    ../darwin-desktop/wumpus-mono.nix
    ../darwin-desktop/fastfetch.nix
    ../darwin-desktop/aria2.nix
    ../darwin-desktop/yt-dlp.nix
    ../darwin-desktop/packages.nix
  ];

  # Spotlight/Alfred don't index the symlinks linkApps creates; stateVersion
  # 25.05 still defaults to linkApps, 25.11+ flips to copyApps.
  targets.darwin.linkApps.enable = false;
  targets.darwin.copyApps.enable = true;
}
