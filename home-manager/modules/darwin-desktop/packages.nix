{ pkgs, ... }: {
  home.packages = with pkgs; [
    # ISO-to-USB flashing; replaces the balenaetcher cask.
    caligula
    ffmpegthumbnailer
  ];
}
