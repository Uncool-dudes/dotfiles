{ pkgs, ... }: {
  home.packages = with pkgs; [
    kind
    kubectl
    kustomize
    postgresql
    stern
    yq-go
    iperf3
    nmap
    dive
  ];
}
