# Not packaged in nixpkgs or homebrew-cask-fonts (eval/demo font); vendor
# the Nerd Font patched build directly from upstream and drop it into
# ~/Library/Fonts so macOS/Ghostty can see it.
{ inputs, ... }:
{
  home.file."Library/Fonts/WumpusMonoNerdFontMono-Regular.ttf".source =
    "${inputs.wumpus-mono}/WumpusMonoNerdFontMono-Regular.ttf";
}
