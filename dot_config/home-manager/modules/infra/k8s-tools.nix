{ pkgs, ... }: {
  home.packages = with pkgs; [
    argocd
    kind
    kubectl
    kustomize
    postgresql
    stern
    terraform
    yq-go
    iperf3
    nmap
    dive
  ];
}
