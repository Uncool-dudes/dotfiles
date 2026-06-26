{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IdentityAgent =
          if pkgs.stdenv.isDarwin
          then "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else "~/.1password/agent.sock";
        SetEnv = { TERM = "xterm-256color"; };
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%r@%h:%p";
        ControlPersist = "10m";
        ServerAliveInterval = 15;
        ServerAliveCountMax = 3;
        ForwardAgent = false;
      };

      "*.ratch.ai" = {
        User = "ananth";
      };

      "git.ananthp.dev" = {
        HostName = "git.ananthp.dev";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_personal";
        IdentitiesOnly = true;
      };
    };
  };
}
