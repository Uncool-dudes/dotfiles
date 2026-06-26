{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "oxocarbon-dark";
      style = "numbers,rule";
      pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
      "map-syntax" = [
        "*.ino:C++"
        ".ignore:Git Ignore"
        "*.env:dotenv"
        "Dockerfile.*:Dockerfile"
        "*.conf:INI"
        "*.tmpl:Go HTML Template"
      ];
    };
    themes = {
      oxocarbon-dark = {
        src = ./bat/themes;
        file = "oxocarbon-dark.tmTheme";
      };
    };
  };
}
