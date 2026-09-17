# modules/devtools.nix
# Development tools, languages, and editors
{ config, pkgs, inputs, ... }: {
  programs.uv = {
    enable = true;
    python = {
      versions = [ "3.13" "3.12" ];
      default = "3.13";
    };
    tool.packages = [
      "black"
      "sqlfluff"
    ];
  };

  programs.go = {
    enable = true;
    telemetry.mode = "off";
    env = {
      GOBIN = "${config.home.homeDirectory}/go/bin";
      GOPRIVATE = [
        "github.com/fabrikiot"
        "github.com/ratchio"
      ];
    };
  };

  programs.pnpm = {
    enable = true;
    pnpmHome = "${config.home.homeDirectory}/.pnpm-global";
  };

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # Editor
    neovim

    # Languages
    fnm
    golangci-lint
    rustup

    # Dev
    abtop
    ast-grep
    claude-code
    ghq
    gitlogue
    hjson-go
    ripgrep-all
    rsync
    just
    tectonic
    typst

    # Kubernetes
    # alloydb-auth-proxy # needs direct GCP VPC/IAM access - use ssh tunnel via dev-api.ratch.ai instead
    argocd
    hadolint
    kind
    kubectl
    kustomize
    postgresql
    sops
    stern
    terraform
    tilt
    yq-go
    _7zz

    # Nix
    deadnix
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    nil
    nixfmt
    nix-tree
    nvd
    statix
  ];

  # Considered and rejected (zero usage in shell history unless noted):
  # croc       - file transfer
  # graphviz   - dot
  # hurl       - scripted HTTP test files (.hurl), none in use currently
  # jujutsu    -
  # virtualenv - redundant, programs.uv already manages python venvs

  programs.nh = {
    enable = true;
    darwinFlake = "${config.home.homeDirectory}/.config/home-manager";
    homeFlake = "${config.home.homeDirectory}/.config/home-manager#uncool@mac";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = [ "--keep" "5" "--keep-since" "1d" ];
    };
  };
}
