{ config, ... }:
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

  # sudo_local survives macOS updates, unlike edits to /etc/pam.d/sudo.
  # reattach: without pam_reattach, Touch ID fails inside tmux/screen.
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # Key remaps live in Karabiner (modules/darwin-desktop/karabiner/). Mapping
  # stays enabled with no entries so activation clears any hidutil remap that
  # would otherwise stack under Karabiner's.
  system.keyboard.enableKeyMapping = true;

  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 57;
      mru-spaces = false;
      show-recents = false;
      persistent-apps = [
        "/Applications/Google Chrome.app"
        "/System/Applications/Calendar.app"
        "/Applications/Superhuman.app"
      ];
      persistent-others = [
        {
          folder = {
            path = "${config.users.users.${config.system.primaryUser}.home}/Downloads";
            arrangement = "date-added";
            showas = "fan";
          };
        }
      ];
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
      NSAutomaticPeriodSubstitutionEnabled = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };

  # Spotlight shortcut off so Alfred owns Cmd+Space; indexing stays on because
  # Alfred's app/file search reads the Spotlight index. The hotkeys use
  # -dict-add since CustomUserPreferences would replace the whole
  # AppleSymbolicHotKeys dict and wipe every other shortcut customization.
  # 64 = Show Spotlight search (Cmd+Space), 65 = Finder search (Cmd+Opt+Space);
  # parameters are (char, keyCode, modifier mask): 32/49 = space,
  # 1048576 = Cmd, 1572864 = Cmd+Opt.
  system.activationScripts.postActivation.text =
    let
      user = config.system.primaryUser;
      asUser = ''launchctl asuser "$(id -u ${user})" sudo --user=${user} --'';
      hotkeyOff = id: modifiers: ''
        ${asUser} /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${id} \
          '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>${modifiers}</integer></array><key>type</key><string>standard</string></dict></dict>'
      '';
    in
    ''
      /usr/bin/mdimport /Applications &

      ${hotkeyOff "64" "1048576"}
      ${hotkeyOff "65" "1572864"}
      ${asUser} /usr/bin/defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
      ${asUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

  system.stateVersion = 7;

  users.users.uncool.home = "/Users/uncool";
  system.primaryUser = "uncool";

  # Little Snitch filters outbound; this covers inbound.
  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
  };

  services.tailscale.enable = true;
}
