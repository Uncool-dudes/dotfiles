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
      "libpq"
      "leptonica"
      "librsvg"
      "mole"
      "openssl@3"
      "pkgconf"
      "postgresql@17"
      "sdl2-compat"
      "rtk"
      "tailscale"
    ];

    casks = [
      "1password"
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
      "postgres-app"
      "raycast"
      "superhuman"
      "tailscale-app"
      "ti-connect-ce"
      "typora"
      "qview"
      "flowvision"
      "rectangle-pro"
      "yubico-authenticator"
      "zoom"
      "zotero"
    ];

    masApps = {
      "Keka"          = 470158793;
      "Mirror Magnet" = 1563698880;
      "WhatsApp"      = 310633997;
      "Tripsy"        = 1429967544;
      "Gestimer 2"    = 6447125648;
      "iA Writer"     = 775737590;
    };
  };
}
