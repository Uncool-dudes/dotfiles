{ config, ... }:
{
  # Symlinks the whole directory, not karabiner.json: Karabiner only hot-reloads
  # when it watches a real directory, and writes from its settings window land
  # back in the repo instead of failing against a read-only store path.
  xdg.configFile."karabiner".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/darwin-desktop/karabiner";
}
