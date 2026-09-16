# modules/common.nix
# Packages shared across all machines
{ pkgs, username, ... }: {

  imports = [
    ./stylix.nix
    ./shell.nix
    ./starship.nix
    ./atuin.nix
    ./bat.nix
    ./eza.nix
    ./fd.nix
    ./yazi.nix
    ./tealdeer.nix
    ./btop.nix
    ./git.nix
    ./ssh.nix
    ./postgres.nix
    ./lazygit.nix
    ./ripgrep.nix
    ./ghostty.nix
    ./gh.nix
    ./jq.nix
    ./k9s.nix
    ./lazydocker.nix
    ./lazyworktree.nix
    ./worktrunk.nix
    ./topgrade.nix
    ./fastfetch.nix
    ./aria2.nix
    ./devtools.nix
    ./direnv.nix
  ];

  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
  programs.parallel = {
    enable = true;
    will-cite = true;
  };

  programs.nix-index.enable = true;
  home.sessionPath = [
    "/nix/var/nix/profiles/default/bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # Shell
    chezmoi

    # Core CLI
    age
    grex
    hl-log-viewer
    procs
    sd
    watchexec
    witr
    xh

    # Git
    act
    convco
    git-absorb
    glow
    lefthook

    # Text / data
    csvlens
    fx
    gum
    pandoc
    tokei

    # System / monitoring
    iperf3
    nmap
    dive
    duf
    dust
    hyperfine
    ov

    # Media
    ffmpeg
    ffmpegthumbnailer
    imagemagick
    vips

    # Backup
    bash
    gnutar
    zstd

    # Secrets
    _1password-cli

    # Misc
    wget
  ];

  # Considered and rejected (zero usage in shell history unless noted):
  # lnav       - duplicate of hl-log-viewer
  # oha        - load-test tool
  # whosthere  -
  # tig        - git TUI browser, redundant with lazygit
  # miller     -
  # onefetch   -
}
