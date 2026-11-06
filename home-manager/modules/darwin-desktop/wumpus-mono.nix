{ pkgs, ... }:
let
  # Not packaged in nixpkgs or homebrew-cask-fonts (eval/demo font); vendor
  # the Nerd Font patched build directly from upstream and drop it into
  # ~/Library/Fonts so macOS/Ghostty can see it.
  src = pkgs.fetchFromGitHub {
    owner = "vaughantype";
    repo = "wumpus-mono";
    rev = "7ff8e034ec253854b16bc3e65d9f47a687703cb5";
    sha256 = "1iwn8x4w5gpvwcz8y2irr6kwccyhxgsdhbvdkc5hhix81cl0irkr";
  };
in
{
  home.file."Library/Fonts/WumpusMonoNerdFontMono-Regular.ttf".source =
    "${src}/WumpusMonoNerdFontMono-Regular.ttf";
}
