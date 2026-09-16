{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IdentityAgent = "\"${config.home.sessionVariables.SSH_AUTH_SOCK}\"";
        SetEnv = { TERM = "xterm-256color"; };
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%C";
        ControlPersist = "10m";
        ServerAliveInterval = 15;
        ServerAliveCountMax = 3;
        ForwardAgent = false;
        HashKnownHosts = true;
        UpdateHostKeys = true;
      };

      "*.ratch.ai" = {
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
      };

      "ssh.ananthp.dev" = {
        HostName = "ssh.ananthp.dev";
        User = "ananth";
        Port = 2222;
      };

      "personal" = {
        HostName = "100.122.211.99";
        User = "ananth";
        Port = 2222;
      };

      "dev1" = {
        HostName = "dev-api.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
      };

      "alloydb" = {
        HostName = "dev-api.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
        LocalForward = "5432 10.8.87.2:5432";
        ExitOnForwardFailure = true;
      };

      "ratch1" = {
        HostName = "ratch1-api.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
      };

      "dev2" = {
        HostName = "dev2.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
      };

      "git.ananthp.dev" = {
        HostName = "git.ananthp.dev";
        User = "git";
        Port = 2223;
        IdentityFile = "~/.ssh/id_ed25519_personal";
      };
    };
  };
}
