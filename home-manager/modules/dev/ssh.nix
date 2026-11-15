{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.autossh ];
  # DataGrip/JetBrains SSH client can't parse a socket path containing spaces
  # (IJPL-63098) - symlink the real 1Password socket to a space-free path.
  home.activation.linkOnePasswordAgentSock = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    if pkgs.stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p "${config.home.homeDirectory}/.1password"
        ln -sf "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
          "${config.home.homeDirectory}/.1password/agent.sock"
      ''
    else
      ""
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

  # Without this file 1Password offers every SSH key in the Personal/Private
  # vault, including repo deploy keys. Order here is the order keys are offered.
  # Item IDs, not titles: a renamed item would otherwise silently stop matching.
  # https://www.1password.dev/ssh/agent/config
  xdg.configFile."1Password/ssh/agent.toml".text = ''
    # work
    [[ssh-keys]]
    item = "phdcv4pk2nnveztrlokotosm44"

    # homelab
    [[ssh-keys]]
    item = "jjf7v5iesmn2bwq33oh5fqcgoy"

    # GitHub Signing - commit signing (op-ssh-sign) goes through the agent.
    [[ssh-keys]]
    item = "ks42nayh7uclm6mhmclydhncpm"

    # boss-aws - EC2 WireGuard server
    [[ssh-keys]]
    item = "oevbxdpuhgmkaurtrwl4g3sara"
  '';

  # Public halves only, used as IdentityFile hints; private keys stay in 1Password.
  home.file.".ssh/work.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSLck8cSsQKyHWuplLX3j6quLixr+xB5kNYWccXtM3G\n";
  home.file.".ssh/homelab.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINW1CCEFlyAt7Xd0/MdYDsbWB8n51oKJVTA3lYSwnIEl\n";
  home.file.".ssh/boss-aws.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfDAsQ5t7esn7/wC44QkSqZMnB5CWfA8xUBeg3prZTv\n";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IdentityAgent = "\"${config.home.sessionVariables.SSH_AUTH_SOCK}\"";
        SetEnv = {
          TERM = "xterm-256color";
        };
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%C";
        ControlPersist = "10m";
        ServerAliveInterval = 15;
        ServerAliveCountMax = 3;
        ForwardAgent = false;
        # Every host must name its key below; a host without an IdentityFile gets no agent keys.
        IdentitiesOnly = true;
        HashKnownHosts = true;
        UpdateHostKeys = true;
      };

      "*.ratch.ai" = {
        User = "ananth";
        IdentityFile = "~/.ssh/work.pub";
      };

      "ssh.ananthp.dev" = {
        HostName = "ssh.ananthp.dev";
        User = "ananth";
        Port = 2222;
        IdentityFile = "~/.ssh/homelab.pub";
      };

      "personal" = {
        HostName = "100.122.211.99";
        User = "ananth";
        Port = 2222;
        IdentityFile = "~/.ssh/homelab.pub";
      };

      "dev1" = {
        HostName = "dev-api.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/work.pub";
      };

      "alloydb" = {
        HostName = "dev-api.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/work.pub";
        LocalForward = "127.0.0.1:5432 10.8.87.2:5432";
        ExitOnForwardFailure = true;
        # A shared master keeps the forward bound after the tunnel exits, so
        # autossh restarts fail with "Address already in use".
        ControlMaster = "no";
        ControlPath = "none";
        ConnectTimeout = 10;
      };

      "ratch1" = {
        HostName = "ratch1-api.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/work.pub";
      };

      "dev2" = {
        HostName = "dev2.ratch.ai";
        User = "ananth";
        IdentityFile = "~/.ssh/work.pub";
      };

      "boss-aws" = {
        HostName = "ec2-13-206-78-239.ap-south-1.compute.amazonaws.com";
        User = "ubuntu";
        IdentityFile = "~/.ssh/boss-aws.pub";
      };

      # Same box over the wg0 tunnel (networking.wg-quick.interfaces.wg0).
      "10.50.0.*" = {
        User = "ubuntu";
        IdentityFile = "~/.ssh/boss-aws.pub";
      };

      "git.ananthp.dev" = {
        HostName = "git.ananthp.dev";
        User = "git";
        Port = 2223;
        IdentityFile = "~/.ssh/homelab.pub";
      };

      # Without a pin, the 1Password agent may offer a repo deploy key first and
      # GitHub authenticates as that repo instead of the account.
      "github.com" = {
        IdentityFile = "~/.ssh/work.pub";
      };
    };
  };
}
