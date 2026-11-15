{ ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Determinate owns the daemon and /etc/nix/nix.conf; these land in
  # /etc/nix/nix.custom.conf. flakes/nix-command are on by default there.
  determinateNix.enable = true;
  determinateNix.customSettings = {
    # Safe on macOS as of Nix 2.35.3: the .tmp-link collision (NixOS/nix#7273,
    # fixed in #14676) and the race with concurrent GC (#15904) are both fixed.
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "uncool"
    ];
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
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
}
