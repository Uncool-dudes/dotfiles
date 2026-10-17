{ config, ... }:
let
  c = config.theme.colors;
  hex = k: "#${c.${k}.hex}";
in
{
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
    # Colors are driven by [[theme.active]] (modules/core/theme.nix); eza has
    # no stylix target, so this reads config.theme.colors instead of a
    # hardcoded palette.
    theme = {
      filekinds = {
        normal.foreground = hex "base05";
        directory = {
          foreground = hex "base0D";
          is_bold = true;
        };
        symlink.foreground = hex "base0C";
        pipe.foreground = hex "base03";
        block_device.foreground = hex "base09";
        char_device.foreground = hex "base09";
        socket.foreground = hex "base0E";
        special.foreground = hex "base09";
        executable = {
          foreground = hex "base0B";
          is_bold = true;
        };
        mount_point = {
          foreground = hex "base0D";
          is_bold = true;
          is_underline = true;
        };
      };

      perms = {
        user_read.foreground = hex "base09";
        group_read.foreground = hex "base09";
        other_read.foreground = hex "base09";
        user_write.foreground = hex "base08";
        group_write.foreground = hex "base08";
        other_write.foreground = hex "base08";
        user_execute_file = {
          foreground = hex "base0B";
          is_bold = true;
        };
        user_execute_other = {
          foreground = hex "base0B";
          is_bold = true;
        };
        group_execute.foreground = hex "base0B";
        other_execute.foreground = hex "base0B";
        special_user_file.foreground = hex "base09";
        special_other.foreground = hex "base09";
        attribute.foreground = hex "base0C";
      };

      size = {
        number_byte.foreground = hex "base0B";
        number_kilo.foreground = hex "base0B";
        number_mega.foreground = hex "base09";
        number_giga.foreground = hex "base08";
        number_huge.foreground = hex "base08";
        unit_byte.foreground = hex "base03";
        unit_kilo.foreground = hex "base03";
        unit_mega.foreground = hex "base03";
        unit_giga.foreground = hex "base03";
        unit_huge.foreground = hex "base03";
      };

      users = {
        user_you = {
          foreground = hex "base0B";
          is_bold = true;
        };
        user_root = {
          foreground = hex "base08";
          is_bold = true;
        };
        user_other.foreground = hex "base05";
        group_yours.foreground = hex "base0B";
        group_other.foreground = hex "base05";
        group_root.foreground = hex "base08";
      };

      links = {
        normal.foreground = hex "base0C";
        multi_link_file.foreground = hex "base09";
      };

      git = {
        new.foreground = hex "base0B";
        modified.foreground = hex "base09";
        deleted.foreground = hex "base08";
        renamed.foreground = hex "base0D";
        ignored.foreground = hex "base03";
        conflicted = {
          foreground = hex "base08";
          is_bold = true;
        };
      };

      git_repo = {
        branch_main = {
          foreground = hex "base0B";
          is_bold = true;
        };
        branch_other.foreground = hex "base0D";
        git_clean.foreground = hex "base0B";
        git_dirty.foreground = hex "base08";
      };

      file_type = {
        image.foreground = hex "base0E";
        video.foreground = hex "base09";
        music.foreground = hex "base0C";
        crypto.foreground = hex "base0B";
        document.foreground = hex "base0D";
        compressed.foreground = hex "base08";
        temp = {
          foreground = hex "base03";
          is_dimmed = true;
        };
        compiled.foreground = hex "base09";
        build = {
          foreground = hex "base09";
          is_bold = true;
          is_underline = true;
        };
        source = {
          foreground = hex "base09";
          is_bold = true;
        };
      };

      punctuation.foreground = hex "base03";
      date.foreground = hex "base0C";
      inode.foreground = hex "base03";
      blocks.foreground = hex "base03";
      header = {
        foreground = hex "base05";
        is_bold = true;
        is_underline = true;
      };
      octal.foreground = hex "base09";
      flags.foreground = hex "base09";
      control_char.foreground = hex "base08";
      broken_symlink = {
        foreground = hex "base08";
        is_bold = true;
      };
      broken_path_overlay = {
        foreground = hex "base03";
        is_strikethrough = true;
      };
    };
  };
}
