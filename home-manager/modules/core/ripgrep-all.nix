{ pkgs, ... }:
let
  # Default build bundles traineddata for every language (~1 GiB).
  tesseract = pkgs.tesseract.override { enableLanguages = [ "eng" ]; };
in
{
  home.packages = [ tesseract ];
  programs.ripgrep-all = {
    enable = true;
    custom_adapters = [
      {
        name = "tesseract";
        description = "OCR images via tesseract";
        extensions = [
          "png"
          "jpg"
          "jpeg"
          "tiff"
          "bmp"
          "gif"
        ];
        binary = "${tesseract}/bin/tesseract";
        args = [
          "stdin"
          "stdout"
        ];
        disabled_by_default = true;
      }
    ];
  };
}
