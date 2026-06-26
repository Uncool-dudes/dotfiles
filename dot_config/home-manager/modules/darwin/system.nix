{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "uncool" ];
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


  };

  system.activationScripts.postActivation.text = ''
    /usr/bin/mdimport /Applications &
  '';

  system.stateVersion = 5;

  users.users.uncool.home = "/Users/uncool";
  system.primaryUser = "uncool";

  environment.systemPackages = [ pkgs.vim ];
}
