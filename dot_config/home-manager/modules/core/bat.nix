{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      style = "numbers,rule";
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
