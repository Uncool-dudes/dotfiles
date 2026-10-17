{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeScriptBin "towebp" (builtins.readFile ./scripts/towebp.zsh))
    (pkgs.writeScriptBin "webpq" (builtins.readFile ./scripts/webpq.zsh))
    (pkgs.writeScriptBin "tohevc" (builtins.readFile ./scripts/tohevc.zsh))
    (pkgs.writeScriptBin "wt" (builtins.readFile ./scripts/wt.zsh))
  ];
}
