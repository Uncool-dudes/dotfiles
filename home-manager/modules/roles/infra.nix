{ ... }:
{
  imports = [
    ../infra/postgres.nix
    ../infra/k9s.nix
    ../infra/k8s-tools.nix
  ];
}
