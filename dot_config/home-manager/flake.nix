{
  description = "Ananth's home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];

      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.home-manager ];
        };
      };

      flake = {
        homeConfigurations =
          let
            mkHome = { system, extraModules ? [] }:
              home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
                modules = [ ./modules/common.nix ./modules/shell.nix ] ++ extraModules;
                extraSpecialArgs = { username = "uncool"; };
              };
          in {
            "uncool@mac"    = mkHome { system = "aarch64-darwin"; extraModules = [ ./modules/darwin.nix ]; };
            "uncool@ubuntu" = mkHome { system = "x86_64-linux";   extraModules = [ ./modules/linux.nix  ]; };
            "uncool@arch"   = mkHome { system = "x86_64-linux";   extraModules = [ ./modules/linux.nix  ]; };
          };
      };
    };
}
