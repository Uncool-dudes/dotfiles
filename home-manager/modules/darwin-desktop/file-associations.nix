{ lib, pkgs, ... }:
let
  # Default app per content type, set with duti on every switch. http/https
  # stay in login-items.nix: changing the browser shows a confirmation
  # dialog, so that step only runs when the browser isn't already Chrome.
  handlers = {
    # adobe-acrobat-pro cask; duti skips it until Acrobat is installed.
    "com.adobe.Acrobat.Pro" = [ "com.adobe.pdf" ];

    "com.aone.keka" = [
      "public.zip-archive"
      "org.7-zip.7-zip-archive"
      "com.rarlab.rar-archive"
      "public.tar-archive"
      "org.gnu.gnu-zip-archive"
    ];

    "com.colliderli.iina" = [
      "public.movie"
      "public.audio"
      "public.mpeg-4"
      "public.mpeg-4-audio"
      "public.mp3"
      "public.mpeg"
      "public.mpeg-2-video"
      "public.mpeg-2-transport-stream"
      "public.avi"
      "public.3gpp"
      "public.3gpp2"
      "public.aac-audio"
      "public.ac3-audio"
      "public.aiff-audio"
      "public.dv-movie"
      "public.m3u-playlist"
      "com.apple.quicktime-movie"
      "com.apple.m4a-audio"
      "com.apple.m4v-video"
      "com.microsoft.waveform-audio"
      "com.microsoft.windows-media-wmv"
      "com.microsoft.windows-media-wma"
      "org.matroska.mkv"
      "org.matroska.mka"
      "org.webmproject.webm"
      "org.xiph.flac"
      "org.xiph.ogg-audio"
    ];

    "com.interversehq.qview" = [
      "public.image"
      "public.png"
      "public.jpeg"
      "public.heic"
      "public.heif"
      "public.tiff"
      "public.avif"
      "public.svg-image"
      "public.camera-raw-image"
      "com.compuserve.gif"
      "com.microsoft.bmp"
      "org.webmproject.webp"
    ];

    "com.google.chrome" = [ "public.html" ];

    # Built by nvim-opener.nix.
    "dev.ananthp.nvim-opener" = [
      "public.plain-text"
      "public.json"
      "public.yaml"
    ];
  };

  urlHandlers = {
    "com.superhuman.electron" = [ "mailto" ];
  };

  dutiFile = pkgs.writeText "file-associations.duti" (
    lib.concatStrings (
      lib.mapAttrsToList (app: types: lib.concatMapStrings (t: "${app} ${t} all\n") types) handlers
      ++ lib.mapAttrsToList (app: schemes: lib.concatMapStrings (s: "${app} ${s}\n") schemes) urlHandlers
    )
  );
in
{
  # duti reports apps that aren't installed yet (e.g. Acrobat on a fresh
  # machine) and exits non-zero; that must not fail the whole switch.
  home.activation.fileAssociations = lib.hm.dag.entryAfter [ "nvimOpener" ] ''
    run ${pkgs.duti}/bin/duti ${dutiFile} || echo "duti: some handlers not set (app not installed?)" >&2
  '';
}
