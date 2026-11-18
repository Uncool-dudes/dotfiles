{ config, ... }:
{
  # Alfred's sync folder is ~/.config/alfred; out-of-store so edits from
  # Alfred Preferences land back in the repo.
  xdg.configFile."alfred".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/darwin-desktop/alfred";
}
