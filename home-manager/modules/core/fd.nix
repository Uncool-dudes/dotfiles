{ ... }:
{
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
      ".DS_Store"
      "target/"
      "dist/"
      ".direnv/"
    ];
  };
}
