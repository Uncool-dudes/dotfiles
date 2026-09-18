{ pkgs, ... }: {
  home.packages = with pkgs; [
    witr
    fx
    gum
    tokei
    duf
    dust
    ov
    chezmoi
    ripgrep-all
    neovim
    ffmpeg
    imagemagick
    _7zz
    glow
    bash
    gnutar
    zstd
    wget
  ];
}
