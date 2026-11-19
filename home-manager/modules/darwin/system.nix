{ config, ... }:
let
  user = "ananth";
in
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
      user
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

  networking.hostName = "mac";
  networking.computerName = "mac";
  networking.localHostName = "mac";

  # sudo_local survives macOS updates, unlike edits to /etc/pam.d/sudo.
  # reattach: without pam_reattach, Touch ID fails inside tmux/screen.
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # macOS default is 5 min; re-prompting that often defeats Touch ID's convenience.
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=30
  '';

  # Key remaps live in Karabiner (modules/darwin-desktop/karabiner/). Mapping
  # stays enabled with no entries so activation clears any hidutil remap that
  # would otherwise stack under Karabiner's.
  system.keyboard.enableKeyMapping = true;

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      tilesize = 57;
      mru-spaces = false;
      show-recents = false;
      expose-group-apps = true;
      # Hot corners. Top-left stays off: the Apple menu lives there and
      # misfires are common.
      wvous-tl-corner = 1; # disabled
      wvous-tr-corner = 12; # Notification Center, where it slides in
      wvous-bl-corner = 3; # application windows
      wvous-br-corner = 14; # Quick Note (macOS default)
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
      _FXSortFoldersFirst = true;
      # Search the current folder, not the whole Mac.
      FXDefaultSearchScope = "SCcf";
      ShowStatusBar = true;
      QuitMenuItem = true;
    };

    # Karabiner leaves the Globe key alone, so stop it opening the emoji picker.
    hitoolbox.AppleFnUsageType = "Do Nothing";

    # Upgrades only when started by hand. Download is a system-level key,
    # set via CustomSystemPreferences below.
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
    CustomSystemPreferences."com.apple.SoftwareUpdate".AutomaticDownload = false;

    WindowManager = {
      # Sonoma default: clicking the wallpaper hides every window.
      EnableStandardClickToShowDesktop = false;
      GloballyEnabled = false; # Stage Manager
    };

    loginwindow.GuestEnabled = false;

    # Reads as "Tue 18 Nov 5:07". macOS can't show the day number without the
    # month; ShowDate = 2 would drop both.
    menuExtraClock = {
      Show24Hour = false;
      ShowAMPM = false;
      ShowDate = 1; # always
      ShowDayOfWeek = true;
      ShowSeconds = false;
      IsAnalog = false;
      FlashDateSeparators = false;
    };

    # Only battery % and the sound picker in the menu bar; the rest stay in
    # Control Center.
    controlcenter = {
      BatteryShowPercentage = true;
      Sound = true;
      Bluetooth = false;
      Display = false;
      AirDrop = false;
      FocusModes = false;
      NowPlaying = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = false;
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
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      PMPrintingExpandedStateForPrint = true;
      # Tab moves focus through every control, not only text fields.
      AppleKeyboardUIMode = 3;
      # Ctrl+Cmd+drag moves a window from anywhere inside it.
      NSWindowShouldDragOnGesture = true;
      AppleShowScrollBars = "WhenScrolling";
      # Clicking the scrollbar track jumps there instead of paging.
      AppleScrollerPagingBehavior = true;
      AppleICUForce24HourTime = false;
      AppleWindowTabbingMode = "fullscreen";
      NSAutomaticWindowAnimationsEnabled = false;
      NSScrollAnimationEnabled = true;
      # Thinner, sharper text on Retina.
      AppleFontSmoothing = 0;
    };

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      # Triggers live in modules/darwin-desktop/bettertouchtool/*.bttpreset,
      # imported by hand; this setting isn't part of a preset export.
      "com.hegenberg.BetterTouchTool" = {
        BTTFocusFollowsMouseEnabled = true;
      };
      # License key comes from 1Password via restore-licenses, not from here.
      "pl.maketheweb.cleanshotx" = {
        analyticsAllowed = false;
        captureWithoutDesktopIcons = true;
        confirmVideoDelete = false;
        cursorHighlightColor = 7;
        cursorHighlightSize = 50;
        cursorHighlightStyle = 0;
        deletePopupAfterDragging = true;
        displayRecordingTime = true;
        doNotDisturbWhileRecording = true;
        highlightClicks = false;
        maxRecordingResolution = 0;
        popupAskForDestinationWhenSaving = false;
        popupSize = 2;
        recordComputerAudio = true;
        showKeystrokes = true;
        snapInAnnotateCrop = true;
        transparentWindowBackground = false;
        videoFPS = 60;
        # Updates come through Homebrew.
        SUAutomaticallyUpdate = false;
        SUEnableAutomaticChecks = false;
      };
    };
  };

  # macOS shortcuts turned off so other tools own the keys:
  # - Spotlight: Alfred owns Cmd+Space; indexing stays on because Alfred's
  #   app/file search reads the Spotlight index.
  # - Input sources: Karabiner makes right option a control key, so
  #   Ctrl+Space switched language.
  # - Mission Control and Spaces: BetterTouchTool owns window/space shortcuts
  #   (its space actions switch natively, not by sending these shortcuts), and
  #   Ctrl+arrows stay free for terminals and editors.
  # - Keyboard focus (Ctrl+F1-F8), VoiceOver (Cmd+F5) and Terminal's man page
  #   services (Cmd+Shift+M/A): collide with IDE bindings (e.g. JetBrains
  #   Find Action) and are easy to trigger by accident.
  # - Screenshots (Cmd+Shift+3/4/5 and their Ctrl copy variants): CleanShot X
  #   owns them.
  # The hotkeys use -dict-add since CustomUserPreferences would replace the
  # whole AppleSymbolicHotKeys dict (or NSServicesStatus) and wipe every other
  # customization.
  # parameters are (char, keyCode, modifier mask): char 65535 = none,
  # keyCode 49 = space, 18 = 1, 20/21/23 = 3/4/5, 123-126 = left/right/down/up, F1-F8 =
  # 122/120/99/118/96/97/98/100; mask 262144 = Ctrl, 131072 = Shift,
  # 524288 = Opt, 1048576 = Cmd, 8388608 = Fn (set on arrow and F keys).
  system.activationScripts.postActivation.text =
    let
      user = config.system.primaryUser;
      asUser = ''launchctl asuser "$(id -u ${user})" sudo --user=${user} --'';
      hotkeyOff = id: char: keyCode: modifiers: ''
        ${asUser} /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${id} \
          '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>${char}</integer><integer>${keyCode}</integer><integer>${modifiers}</integer></array><key>type</key><string>standard</string></dict></dict>'
      '';
      serviceOff = name: ''
        ${asUser} /usr/bin/defaults write pbs NSServicesStatus -dict-add '${name}' \
          '<dict><key>enabled_context_menu</key><false/><key>enabled_services_menu</key><false/><key>presentation_modes</key><dict><key>ContextMenu</key><false/><key>ServicesMenu</key><false/></dict></dict>'
      '';
    in
    ''
      /usr/bin/mdimport /Applications &

      ${hotkeyOff "64" "32" "49" "1048576"} # Show Spotlight search: Cmd+Space
      ${hotkeyOff "65" "32" "49" "1572864"} # Finder search window: Cmd+Opt+Space
      ${hotkeyOff "60" "32" "49" "262144"} # Previous input source: Ctrl+Space
      ${hotkeyOff "61" "32" "49" "786432"} # Next input source: Ctrl+Opt+Space
      ${hotkeyOff "32" "65535" "126" "8650752"} # Mission Control: Ctrl+Up
      ${hotkeyOff "34" "65535" "126" "8781824"} # Mission Control: Ctrl+Shift+Up
      ${hotkeyOff "33" "65535" "125" "8650752"} # Application windows: Ctrl+Down
      ${hotkeyOff "35" "65535" "125" "8781824"} # Application windows: Ctrl+Shift+Down
      ${hotkeyOff "79" "65535" "123" "8650752"} # Move left a space: Ctrl+Left
      ${hotkeyOff "80" "65535" "123" "8781824"} # Move left a space: Ctrl+Shift+Left
      ${hotkeyOff "81" "65535" "124" "8650752"} # Move right a space: Ctrl+Right
      ${hotkeyOff "82" "65535" "124" "8781824"} # Move right a space: Ctrl+Shift+Right
      ${hotkeyOff "118" "65535" "18" "262144"} # Switch to Desktop 1: Ctrl+1
      ${hotkeyOff "12" "65535" "122" "8650752"} # Turn keyboard access on/off: Ctrl+F1
      ${hotkeyOff "7" "65535" "120" "8650752"} # Move focus to menu bar: Ctrl+F2
      ${hotkeyOff "8" "65535" "99" "8650752"} # Move focus to Dock: Ctrl+F3
      ${hotkeyOff "9" "65535" "118" "8650752"} # Move focus to active/next window: Ctrl+F4
      ${hotkeyOff "10" "65535" "96" "8650752"} # Move focus to window toolbar: Ctrl+F5
      ${hotkeyOff "11" "65535" "97" "8650752"} # Move focus to floating window: Ctrl+F6
      ${hotkeyOff "13" "65535" "98" "8650752"} # Change the way Tab moves focus: Ctrl+F7
      ${hotkeyOff "57" "65535" "100" "8650752"} # Move focus to status menus: Ctrl+F8
      ${hotkeyOff "59" "65535" "96" "9437184"} # Turn VoiceOver on/off: Cmd+F5
      ${hotkeyOff "28" "51" "20" "1179648"} # Save picture of screen: Cmd+Shift+3
      ${hotkeyOff "29" "51" "20" "1441792"} # Copy picture of screen: Ctrl+Cmd+Shift+3
      ${hotkeyOff "30" "52" "21" "1179648"} # Save picture of area: Cmd+Shift+4
      ${hotkeyOff "31" "52" "21" "1441792"} # Copy picture of area: Ctrl+Cmd+Shift+4
      ${hotkeyOff "184" "53" "23" "1179648"} # Screenshot and recording options: Cmd+Shift+5
      ${serviceOff "com.apple.Terminal - Open man Page in Terminal - openManPage"} # Cmd+Shift+M
      ${serviceOff "com.apple.Terminal - Search man Page Index in Terminal - searchManPages"} # Cmd+Shift+A
      ${asUser} /System/Library/CoreServices/pbs -flush
      ${asUser} /usr/bin/defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
      ${asUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

  system.stateVersion = 7;

  users.users.${user}.home = "/Users/${user}";
  system.primaryUser = user;

  # Little Snitch filters outbound; this covers inbound.
  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
  };

  services.tailscale.enable = true;

  # Split tunnel to the EC2 WireGuard server: only 10.50.0.0/24 routes through
  # it. The module also installs wireguard-tools and wireguard-go system-wide.
  # Private key lives outside the nix store (world-readable) and git; create it
  # once by hand, root-owned, mode 600.
  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.50.0.2/24" ];
    privateKeyFile = "/etc/wireguard/wg0.key";
    # wg-quick's default 1420 exceeds the path MTU to EC2 here; packets over
    # ~1280 vanish, so SSH authenticates then hangs on the first full-size reply.
    mtu = 1280;
    peers = [
      {
        publicKey = "zTV0WvxF/qDHtuTbNs7hc4IwXmwV+3Q0CliD08a/lQY=";
        endpoint = "ec2-13-206-78-239.ap-south-1.compute.amazonaws.com:51820";
        allowedIPs = [ "10.50.0.0/24" ];
        persistentKeepalive = 25;
      }
    ];
  };
}
