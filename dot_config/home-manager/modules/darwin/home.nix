{ ... }:
{
  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/share/google-cloud-sdk/bin"
  ];

  targets.darwin.defaults."com.apple.desktopservices" = {
    DSDontWriteNetworkStores = true;
    DSDontWriteUSBStores = true;
  };
}
