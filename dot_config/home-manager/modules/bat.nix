{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
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
  };
}
