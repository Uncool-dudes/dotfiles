{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IdentityAgent =
          if pkgs.stdenv.hostPlatform.isDarwin
          then "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else "~/.1password/agent.sock";
        SetEnv = { TERM = "xterm-256color"; };
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%C";
        ControlPersist = "10m";
        ServerAliveInterval = 15;
        ServerAliveCountMax = 3;
        ForwardAgent = false;
      };

      "*.ratch.ai" = {
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
        IdentitiesOnly = true;
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
        IdentitiesOnly = true;
      };

      "alloydb" = {
        HostName = "dev-api.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
        IdentitiesOnly = true;
        LocalForward = "5433 10.8.87.2:5432";
        ExitOnForwardFailure = true;
      };

      "ratch1" = {
        HostName = "ratch1-api.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
        IdentitiesOnly = true;
      };

      "dev2" = {
        HostName = "dev2.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/id_ed25519_work";
        IdentitiesOnly = true;
      };

      "git.ananthp.dev" = {
        HostName = "git.ananthp.dev";
        User = "git";
        Port = 2223;
        IdentityFile = "~/.ssh/id_ed25519_personal";
        IdentitiesOnly = true;
      };
    };
  };

  home.file.".pg_service.conf".text = ''
    [alloydb]
    host=localhost
    port=5433
    user=postgres
  '';
}
