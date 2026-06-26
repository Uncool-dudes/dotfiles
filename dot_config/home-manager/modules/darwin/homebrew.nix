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
      "tailscale"
    ];

    casks = [
      "1password"
      "affinity-photo"
      "anki"
      "bettertouchtool"
      "cleanshot"
      "docker-desktop"
      "font-geist-mono-nerd-font"
      "font-go-mono-nerd-font"
      "font-inter"
      "font-iosevka-nerd-font"
      "font-iosevka-ss08"
      "font-iosevka-ss18"
      "font-victor-mono-nerd-font"
      "font-zed-mono-nerd-font"
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
      "netnewswire"
      "ngrok"
      "pdf-expert"
      "popclip"
      "postgres-app"
      "qview"
      "rar"
      "raycast"
      "slack"
      "superhuman"
      "tailscale-app"
      "ti-connect-ce"
      "typora"
      "yubico-authenticator"
      "zoom"
      "zotero"
    ];

    masApps = {
      "Keka"          = 425424353;
      "Mirror Magnet" = 1563698880;
      "WhatsApp"      = 310633997;
      "Tripsy"        = 1429967544;
      "Gestimer"      = 990588172;
      "iA Writer"     = 775737590;
    };
  };
}
