{ pkgs, ... }:
let
  yazi-rs-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "f703392df78b5fba5e8f9f1ad0b1cb6d3def9736";
    hash = "sha256-O1yYAhsf7xMqUrTTSLac06WSxCvUQqedH3DWqGwn/Ok=";
  };

  yazi-rs-plugin = name: pkgs.runCommand name { } "cp -r ${yazi-rs-plugins}/${name} $out";

  # upstream archived/deprecated; pinned only through yazi v26.9.1 - may break on future yazi bumps
  restore-yazi = pkgs.fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "864dd054e0c8029dc90e8a62067945cf053d6533";
    hash = "sha256-HRnHjCTvcuX0R2uDQQRqCF8sWtIquSyt8veSgk7MTqk=";
  };

in
{
  home.packages = [ pkgs.poppler-utils pkgs.trash-cli ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    plugins = {
      chmod = yazi-rs-plugin "chmod.yazi";
      smart-filter = yazi-rs-plugin "smart-filter.yazi";
      restore = restore-yazi;
    };
    keymap = {
      mgr.prepend_keymap = [
        { run = "plugin chmod"; on = [ "c" "m" ]; }
        { run = "plugin smart-filter"; on = [ "f" ]; }
        { run = "plugin restore"; on = [ "u" ]; }
      ];
    };
    settings = {
      mgr = {
        show_hidden = false;
        linemode = "size";
        sort_by = "mtime";
        sort_reverse = true;
        sort_dir_first = true;
      };
      preview = {
        image_filter = "triangle";
        max_width = 1000;
        max_height = 800;
      };
      tasks = {
        preload_workers = 15;
        fetch_workers = 10;
      };
      opener = {
        markdown = [ { run = ''glow "$@"''; block = true; } ];
        json = [ { run = ''fx "$@"''; block = true; } ];
      };
      open.prepend_rules = [
        { mime = "text/markdown"; use = "markdown"; }
        { mime = "application/json"; use = "json"; }
      ];
    };
  };
}
