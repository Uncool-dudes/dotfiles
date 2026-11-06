{ pkgs, ... }:
let
  yazi-rs-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "9166202cc1694c98bac3a639874d6f4c0eaa2dab";
    hash = "sha256-3ddGRQSzxyurNcyYJA+9LTLXTCjBFGATTqdkuGKixzA=";
  };

  yazi-rs-plugin = name: pkgs.runCommand name { } "cp -r ${yazi-rs-plugins}/${name} $out";

in
{
  home.packages = [
    pkgs.poppler-utils
    pkgs.trash-cli
  ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    plugins = {
      chmod = yazi-rs-plugin "chmod.yazi";
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          run = "plugin chmod";
          on = [
            "c"
            "m"
          ];
        }
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
        markdown = [
          {
            run = ''glow "$@"'';
            block = true;
          }
        ];
        json = [
          {
            run = ''fx "$@"'';
            block = true;
          }
        ];
      };
      open.prepend_rules = [
        {
          mime = "text/markdown";
          use = "markdown";
        }
        {
          mime = "application/json";
          use = "json";
        }
      ];
    };
  };
}
