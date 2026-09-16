{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
      autoUpdate = true;
    };

    brews = [
      "mole"
      "rtk"
    ];

    casks = [
      "adobe-creative-cloud"
      "gcloud-cli"
      "1password"
      "beekeeper-studio"
      "bettertouchtool"
      "cleanshot"
      "docker-desktop"
      "font-geist-mono-nerd-font"
      "font-iosevka-nerd-font"
      "font-iosevka-ss08"
      "font-victor-mono-nerd-font"
      "ghostty"
      "google-chrome"
      "hazel"
      "iina"
      "jetbrains-toolbox"
      "little-snitch"
      "megasync"
      "microsoft-auto-update"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-word"
      "mochi"
      "mullvad-vpn"
      "ngrok"
      "pdf-expert"
      "popclip"
      "raycast"
      "renamer"
      "steam"
      "superhuman"
      "ti-connect-ce"
      "typora"
      "qview"
      "yubico-authenticator"
      "zoom"
      "zotero"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Keka" = 470158793;
      "Mirror Magnet" = 1563698880;
      "WhatsApp" = 310633997;
      "Tripsy" = 1429967544;
      "Gestimer 2" = 6447125648;
      "iA Writer" = 775737590;
    };
  };
}
