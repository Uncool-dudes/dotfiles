{ ... }:
{
  home.sessionPath = [ "/opt/homebrew/bin" ];

  targets.darwin.defaults."com.apple.desktopservices" = {
    DSDontWriteNetworkStores = true;
    DSDontWriteUSBStores = true;
  };
}
