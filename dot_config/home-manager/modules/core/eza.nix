{ ... }:
{
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
    # Colors mirror themes/base16-oxocarbon-dark.yaml (base0X hex below);
    # eza has no stylix target, so this needs manual sync if the scheme changes.
    theme = {
      filekinds = {
        normal.foreground = "#f2f4f8"; # base05
        directory = {
          foreground = "#33b1ff"; # base0D
          is_bold = true;
        };
        symlink.foreground = "#3ddbd9"; # base0C
        pipe.foreground = "#525252"; # base03
        block_device.foreground = "#ff6f00"; # base0A
        char_device.foreground = "#ff6f00"; # base0A
        socket.foreground = "#be95ff"; # base0E
        special.foreground = "#ff7eb6"; # base09
        executable = {
          foreground = "#42be65"; # base0B
          is_bold = true;
        };
        mount_point = {
          foreground = "#33b1ff"; # base0D
          is_bold = true;
          is_underline = true;
        };
      };

      perms = {
        user_read.foreground = "#ff6f00"; # base0A
        group_read.foreground = "#ff6f00";
        other_read.foreground = "#ff6f00";
        user_write.foreground = "#ee5396"; # base08
        group_write.foreground = "#ee5396";
        other_write.foreground = "#ee5396";
        user_execute_file = {
          foreground = "#42be65"; # base0B
          is_bold = true;
        };
        user_execute_other = {
          foreground = "#42be65";
          is_bold = true;
        };
        group_execute.foreground = "#42be65";
        other_execute.foreground = "#42be65";
        special_user_file.foreground = "#ff7eb6"; # base09
        special_other.foreground = "#ff7eb6";
        attribute.foreground = "#3ddbd9"; # base0C
      };

      size = {
        number_byte.foreground = "#42be65"; # base0B
        number_kilo.foreground = "#42be65";
        number_mega.foreground = "#ff6f00"; # base0A
        number_giga.foreground = "#ee5396"; # base08
        number_huge.foreground = "#ee5396";
        unit_byte.foreground = "#525252"; # base03
        unit_kilo.foreground = "#525252";
        unit_mega.foreground = "#525252";
        unit_giga.foreground = "#525252";
        unit_huge.foreground = "#525252";
      };

      users = {
        user_you = {
          foreground = "#42be65"; # base0B
          is_bold = true;
        };
        user_root = {
          foreground = "#ee5396"; # base08
          is_bold = true;
        };
        user_other.foreground = "#f2f4f8"; # base05
        group_yours.foreground = "#42be65";
        group_other.foreground = "#f2f4f8";
        group_root.foreground = "#ee5396";
      };

      links = {
        normal.foreground = "#3ddbd9"; # base0C
        multi_link_file.foreground = "#ff7eb6"; # base09
      };

      git = {
        new.foreground = "#42be65"; # base0B
        modified.foreground = "#ff6f00"; # base0A
        deleted.foreground = "#ee5396"; # base08
        renamed.foreground = "#33b1ff"; # base0D
        ignored.foreground = "#525252"; # base03
        conflicted = {
          foreground = "#ee5396"; # base08
          is_bold = true;
        };
      };

      git_repo = {
        branch_main = {
          foreground = "#42be65"; # base0B
          is_bold = true;
        };
        branch_other.foreground = "#33b1ff"; # base0D
        git_clean.foreground = "#42be65";
        git_dirty.foreground = "#ee5396"; # base08
      };

      file_type = {
        image.foreground = "#be95ff"; # base0E
        video.foreground = "#ff7eb6"; # base09
        music.foreground = "#3ddbd9"; # base0C
        crypto.foreground = "#42be65"; # base0B
        document.foreground = "#33b1ff"; # base0D
        compressed.foreground = "#ee5396"; # base08
        temp = {
          foreground = "#525252"; # base03
          is_dimmed = true;
        };
        compiled.foreground = "#ff6f00"; # base0A
        build = {
          foreground = "#ff6f00";
          is_bold = true;
          is_underline = true;
        };
        source = {
          foreground = "#ff6f00";
          is_bold = true;
        };
      };

      punctuation.foreground = "#525252"; # base03
      date.foreground = "#3ddbd9"; # base0C
      inode.foreground = "#525252"; # base03
      blocks.foreground = "#525252"; # base03
      header = {
        foreground = "#f2f4f8"; # base05
        is_bold = true;
        is_underline = true;
      };
      octal.foreground = "#ff6f00"; # base0A
      flags.foreground = "#ff7eb6"; # base09
      control_char.foreground = "#ee5396"; # base08
      broken_symlink = {
        foreground = "#ee5396"; # base08
        is_bold = true;
      };
      broken_path_overlay = {
        foreground = "#525252"; # base03
        is_strikethrough = true;
      };
    };
  };
}
