# base16 palette data for the flexoki-dark scheme. Role meaning per base16
# spec: 00 bg, 01 bgAlt, 02 selection, 03 comment, 04 fgDark, 05 fg, 06
# fgLight, 07 fgLightest, 08 red, 09 orange, 0A yellow, 0B green, 0C cyan,
# 0D blue, 0E purple, 0F brown/magenta.
# Source: https://github.com/kepano/flexoki via tinted-theming/schemes
# (spec-0.11/base16/flexoki-dark.yaml).
{
  scheme = "Flexoki Dark";
  author = "Steph Ango (https://github.com/kepano/flexoki)";
  base00 = {
    hex = "100f0f";
    rgb = {
      r = 16;
      g = 15;
      b = 15;
    };
  };
  base01 = {
    hex = "1c1b1a";
    rgb = {
      r = 28;
      g = 27;
      b = 26;
    };
  };
  base02 = {
    hex = "282726";
    rgb = {
      r = 40;
      g = 39;
      b = 38;
    };
  };
  base03 = {
    hex = "575653";
    rgb = {
      r = 87;
      g = 86;
      b = 83;
    };
  };
  base04 = {
    hex = "878580";
    rgb = {
      r = 135;
      g = 133;
      b = 128;
    };
  };
  base05 = {
    hex = "cecdc3";
    rgb = {
      r = 206;
      g = 205;
      b = 195;
    };
  };
  base06 = {
    hex = "e6e4d9";
    rgb = {
      r = 230;
      g = 228;
      b = 217;
    };
  };
  base07 = {
    hex = "fffcf0";
    rgb = {
      r = 255;
      g = 252;
      b = 240;
    };
  };
  base08 = {
    hex = "d14d41";
    rgb = {
      r = 209;
      g = 77;
      b = 65;
    };
  };
  base09 = {
    hex = "da702c";
    rgb = {
      r = 218;
      g = 112;
      b = 44;
    };
  };
  base0A = {
    hex = "d0a215";
    rgb = {
      r = 208;
      g = 162;
      b = 21;
    };
  };
  base0B = {
    hex = "879a39";
    rgb = {
      r = 135;
      g = 154;
      b = 57;
    };
  };
  base0C = {
    hex = "3aa99f";
    rgb = {
      r = 58;
      g = 169;
      b = 159;
    };
  };
  base0D = {
    hex = "4385be";
    rgb = {
      r = 67;
      g = 133;
      b = 190;
    };
  };
  base0E = {
    hex = "8b7ec8";
    rgb = {
      r = 139;
      g = 126;
      b = 200;
    };
  };
  base0F = {
    hex = "ce5d97";
    rgb = {
      r = 206;
      g = 93;
      b = 151;
    };
  };
  # base24 extension (https://github.com/tinted-theming/base24/blob/master/styling.md)
  # - these are the "600-weight" accent shades from upstream Flexoki, used by
  # base16.nix's mnemonic bright-* fallbacks (base12=bright-red, base13=bright-yellow,
  # base14=bright-green, base15=bright-cyan, base16=bright-blue, base17=bright-magenta).
  # without these, bright-* just duplicates the normal base08-0E accent above.
  base12 = {
    hex = "af3029";
    rgb = {
      r = 175;
      g = 48;
      b = 41;
    };
  };
  base13 = {
    hex = "ad8301";
    rgb = {
      r = 173;
      g = 131;
      b = 1;
    };
  };
  base14 = {
    hex = "66800b";
    rgb = {
      r = 102;
      g = 128;
      b = 11;
    };
  };
  base15 = {
    hex = "24837b";
    rgb = {
      r = 36;
      g = 131;
      b = 123;
    };
  };
  base16 = {
    hex = "205ea6";
    rgb = {
      r = 32;
      g = 94;
      b = 166;
    };
  };
  base17 = {
    hex = "a02f6f";
    rgb = {
      r = 160;
      g = 47;
      b = 111;
    };
  };
}
