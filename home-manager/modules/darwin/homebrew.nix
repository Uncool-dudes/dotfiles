{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "uninstall";
      upgrade = false;
      autoUpdate = false;
    };

    brews = [
      "blueutil"
      "mole"
      "rtk"
    ];

    casks = [
      "adobe-creative-cloud"
      "gcloud-cli"
      "1password"
      "1password-cli"
      "alfred"
      "balenaetcher"
      "bettertouchtool"
      "calibre"
      "claude"
      "cleanshot"
      "devonthink"
      "docker-desktop"
      "font-geist-mono-nerd-font"
      "font-iosevka-nerd-font"
      "font-iosevka-ss08"
      "font-victor-mono-nerd-font"
      "google-chrome"
      "hazel"
      "iina"
      "jetbrains-toolbox"
      # Cask over nix-darwin's services.karabiner-elements: that module recopies
      # the driver app on every switch (re-prompting for permissions) and nixpkgs
      # lags upstream.
      "karabiner-elements"
      "little-snitch"
      "megasync"
      "microsoft-auto-update"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-word"
      "mochi"
      "mullvad-vpn"
      "ngrok"
      "paste"
      "popclip"
      "postman"
      "renamer"
      "soulver"
      "superhuman"
      "tg-pro"
      "ti-connect-ce"
      "typora"
      "visual-studio-code"
      "qview"
      "yubico-authenticator"
      "zotero"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "EdgeView 3" = 1580323719;
      "Keka" = 470158793;
      "WhatsApp" = 310633997;
      "Gestimer 2" = 6447125648;
      "Things 3" = 904280696;
    };
  };
}
