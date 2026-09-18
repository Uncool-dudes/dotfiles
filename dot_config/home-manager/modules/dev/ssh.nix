{ config, lib, pkgs, ... }:
{
  # DataGrip/JetBrains SSH client can't parse a socket path containing spaces
  # (IJPL-63098) - symlink the real 1Password socket to a space-free path.
  home.activation.linkOnePasswordAgentSock = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    if pkgs.stdenv.hostPlatform.isDarwin then ''
      mkdir -p "${config.home.homeDirectory}/.1password"
      ln -sf "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
        "${config.home.homeDirectory}/.1password/agent.sock"
    '' else ""
  );

  launchd.agents.ssh-auth-sock-setenv = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/launchctl"
        "setenv"
        "SSH_AUTH_SOCK"
        config.home.sessionVariables.SSH_AUTH_SOCK
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

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
