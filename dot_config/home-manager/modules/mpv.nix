{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
      sponsorblock
      autoload
    ];

    config = {
      # Renderer
      vo = "gpu-next";
      hwdec = if pkgs.stdenv.isDarwin then "videotoolbox" else "auto-safe";
      profile = "gpu-hq";

      # Playback
      save-position-on-quit = true;
      keep-open = true;

      # UI — uosc replaces the default osc
      osc = false;
      osd-bar = false;

      # ytdl
      ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";

      # Audio
      audio-normalize-downmix = true;
      volume-max = 150;

      # Subtitles
      sub-auto = "fuzzy";
      sub-font-size = 44;
      sub-border-size = 2;

      # Screenshots
      screenshot-format = "png";
      screenshot-directory = "~/Pictures/Screenshots";
    };

    profiles.anime = {
      profile = "gpu-hq";
      deband = true;
      deband-iterations = 4;
    };

    scriptOpts = {
      thumbfast = {
        network = true;
        osc = true;
      };
      sponsorblock = {
        categories = "sponsor,intro,outro,interaction,selfpromo";
      };
    };
  };
}
