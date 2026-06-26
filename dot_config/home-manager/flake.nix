{
  description = "Ananth's home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, home-manager, nix-darwin, stylix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];

      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.home-manager ];
        };
      };

      flake = {
        darwinConfigurations."Ananths-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { username = "uncool"; inherit inputs; };
              home-manager.users.uncool = { ... }: {
                imports = [
                  ./modules/common.nix
                  ./modules/darwin/home.nix
                ];
                _module.args.username = "uncool";
              };
            }
          ];
        };

        homeConfigurations =
          let
            mkHome = { system, extraModules ? [] }:
              home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
                modules = [ ./modules/common.nix ] ++ extraModules;
                extraSpecialArgs = { username = "uncool"; inherit inputs; };
              };
          in {
            "uncool@mac"    = mkHome { system = "aarch64-darwin"; extraModules = [ ./modules/darwin/home.nix ]; };
            "uncool@ubuntu" = mkHome { system = "x86_64-linux";   extraModules = [ ./modules/ubuntu.nix ]; };
            "uncool@arch"   = mkHome { system = "x86_64-linux";   extraModules = [ ./modules/arch.nix   ]; };
          };
      };
    };
}
