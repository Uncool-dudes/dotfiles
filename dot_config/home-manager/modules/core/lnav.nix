{ config, ... }:
let
  c = config.theme.colors;
  hex = k: "#${c.${k}.hex}";
in
{
  home.file.".config/lnav/config.json".text = builtins.toJSON {
    "$schema" = "https://lnav.org/schemas/config-v1.schema.json";
    ui = {
      theme = "oxocarbon";
      theme-defs.oxocarbon = {
        vars = {
          black = hex "base00";
          bg_alt = hex "base01";
          selection = hex "base02";
          gray = hex "base03";
          fg_dark = hex "base04";
          fg = hex "base05";
          white = hex "base06";
          red = hex "base08";
          orange = hex "base09";
          yellow = hex "base0A";
          green = hex "base0B";
          cyan = hex "base0C";
          blue = hex "base0D";
          violet = hex "base0E";
          magenta = hex "base0F";
        };
        styles = {
          identifier.color = "semantic()";
          text = {
            color = "$fg_dark";
            background-color = "$black";
          };
          selected-text.background-color = "$selection";
          fuzzy-match = {
            color = "$orange";
            underline = true;
            bold = true;
          };
          alt-text.background-color = "$bg_alt";
          ok = {
            color = "$green";
            bold = true;
          };
          info = {
            color = "$blue";
            bold = true;
          };
          error = {
            color = "$red";
            bold = true;
          };
          warning = {
            color = "$orange";
            bold = true;
          };
          hidden = {
            color = "$orange";
            bold = true;
          };
          cursor-line = {
            color = "$cyan";
            background-color = "$selection";
            bold = true;
          };
          time-column.background-color = "$selection";
          adjusted-time.color = "$violet";
          skewed-time.color = "$orange";
          offset-time.color = "$cyan";
          time-ago.bold = true;
          popup = {
            color = "$fg";
            background-color = "$bg_alt";
          };
          popup-border = {
            color = "$cyan";
            background-color = "$bg_alt";
          };
          scrollbar = {
            color = "$black";
            background-color = "$fg_dark";
          };
          timeline-bar.background-color = "$violet";
          context-line.background-color = "$bg_alt";
          focused = {
            color = "$black";
            background-color = "$gray";
          };
          disabled-focused = {
            color = "$fg_dark";
            background-color = "$selection";
          };
          h1 = {
            color = "$violet";
            bold = true;
          };
          h2 = {
            color = "$violet";
            underline = true;
          };
          h3.color = "$violet";
          h4.underline = true;
          h5.italic = true;
          h6.italic = true;
          hr.color = "$gray";
          hyperlink.underline = true;
          list-glyph.color = "$orange";
          breadcrumb = {
            color = "$fg_dark";
            bold = true;
          };
          table-border.color = "$gray";
          table-header = {
            color = "$fg";
            bold = true;
          };
          quote-border = {
            color = "$gray";
            background-color = "$bg_alt";
          };
          quoted-text.background-color = "$bg_alt";
          footnote-border = {
            color = "$blue";
            background-color = "$bg_alt";
          };
          footnote-text = {
            color = "$fg";
            background-color = "$bg_alt";
          };
          snippet-border.color = "$cyan";
          indent-guide.color = "$gray";
        };
        syntax-styles = {
          inline-code = {
            color = "$red";
            background-color = "$black";
          };
          quoted-code = {
            color = "$fg";
            background-color = "$black";
          };
          code-border = {
            color = "$gray";
            background-color = "$black";
          };
          object-key.color = "semantic()";
          keyword.color = "$orange";
          string = {
            color = "$cyan";
            bold = true;
          };
          comment.color = "$gray";
          doc-directive.color = "$cyan";
          variable.color = "$blue";
          symbol.color = "$blue";
          re-special.color = "$cyan";
          re-repeat.color = "$orange";
          diff-delete.color = "$red";
          diff-add.color = "$green";
          diff-section.color = "$violet";
          spectrogram-low = {
            color = "$black";
            background-color = "$green";
            bold = true;
          };
          spectrogram-medium = {
            color = "$black";
            background-color = "$orange";
            bold = true;
          };
          spectrogram-high = {
            color = "$black";
            background-color = "$red";
            bold = true;
          };
          file.color = "$blue";
          null.color = "$gray";
          ascii-control.color = "$green";
          non-ascii.color = "$orange";
          number.bold = true;
          function.color = "$cyan";
          separators-references-accessors.color = "$red";
          type.color = "$blue";
        };
        status-styles = {
          disabled-title = {
            color = "$gray";
            background-color = "$black";
            bold = true;
          };
          title = {
            color = "$black";
            background-color = "$blue";
            bold = true;
          };
          alert-title = {
            color = "$red";
            background-color = "$blue";
            bold = true;
          };
          subtitle = {
            color = "$black";
            background-color = "$cyan";
            bold = true;
          };
          text = {
            color = "$white";
            background-color = "$selection";
          };
          warn = {
            color = "$orange";
            background-color = "$selection";
          };
          alert = {
            color = "$red";
            background-color = "$selection";
          };
          active = {
            color = "$green";
            background-color = "$selection";
          };
          info = {
            color = "$fg_dark";
            background-color = "$bg_alt";
          };
          title-hotkey = {
            color = "$black";
            background-color = "$blue";
            underline = true;
          };
          hotkey = {
            color = "$white";
            underline = true;
          };
          inactive = {
            color = "$fg_dark";
            background-color = "$bg_alt";
          };
          inactive-warn = {
            color = "$orange";
            background-color = "$bg_alt";
          };
          inactive-alert = {
            color = "$red";
            background-color = "$bg_alt";
          };
          suggestion.color = "$bg_alt";
        };
        log-level-styles = {
          warning.color = "$orange";
          error.color = "$red";
          critical.color = "$red";
          fatal.color = "$red";
        };
      };
    };
  };
}
