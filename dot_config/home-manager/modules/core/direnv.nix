{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = false;
    silent = true;
    config.global.warn_timeout = "30s";
  };
}
