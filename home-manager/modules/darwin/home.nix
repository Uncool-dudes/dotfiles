{ config, ... }:
{
  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/share/google-cloud-sdk/bin"
  ];

  # Soulver cask ships its CLI inside the app bundle without linking it onto PATH.
  home.file.".local/bin/soulver".source =
    config.lib.file.mkOutOfStoreSymlink "/Applications/Soulver 3.app/Contents/MacOS/CLI/soulver";
}
