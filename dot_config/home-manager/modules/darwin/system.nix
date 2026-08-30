{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "uncool" ];
    auto-optimise-store = true;
    extra-substituters = [
      "https://cachix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
    ];
  };

  networking.hostName = "Ananths-MacBook-Pro";

  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 57;
      mru-spaces = false;
      show-recents = false;
    };

    finder = {
      FXPreferredViewStyle = "clmv";
      NewWindowTarget = "Home";
      ShowExternalHardDrivesOnDesktop = true;
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
    };

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };

  system.activationScripts.postActivation.text = ''
    /usr/bin/mdimport /Applications &
  '';

  system.stateVersion = 7;

  users.users.uncool.home = "/Users/uncool";
  system.primaryUser = "uncool";

  services.tailscale.enable = true;


  environment.systemPackages = [ pkgs.vim ];
}
