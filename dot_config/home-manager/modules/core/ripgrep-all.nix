{ pkgs, ... }:
{
  home.packages = [ pkgs.tesseract ];

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
        binary = "${pkgs.tesseract}/bin/tesseract";
        args = [
          "stdin"
          "stdout"
        ];
        disabled_by_default = true;
      }
    ];
  };
}
