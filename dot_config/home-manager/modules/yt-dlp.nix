{ ... }:
{
  programs.yt-dlp = {
    enable = true;
    settings = {
      format = "bestvideo[height<=?1080]+bestaudio/best";
      embed-thumbnail = true;
      embed-subs = true;
      sub-langs = "en.*,ja";
      output = "~/Downloads/%(title)s.%(ext)s";
      sponsorblock-mark = "sponsor,intro,outro,selfpromo";
      external-downloader = "aria2c";
      external-downloader-args = "aria2c:-x16 -s16 -k1M";
    };
  };
}
