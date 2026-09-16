{
  description = "Ananth's home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    alloydb-auth-proxy-src = {
      url = "github:GoogleCloudPlatform/alloydb-auth-proxy";
      flake = false;
    };
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
    let
      overlays = [
        # nixpkgs-unstable lags go.dev releases by weeks (source-build + channel
        # promotion gate). go_1_27 is already merged and cached on nixpkgs master.
        (final: prev: {
          go = (import inputs.nixpkgs-master { system = prev.stdenv.hostPlatform.system; }).go_1_27;
        })

        # Not packaged in nixpkgs or homebrew; built from upstream source so
        # `nix flake update` keeps it current instead of manual version bumps.
        (final: prev: {
          alloydb-auth-proxy = prev.buildGoModule {
            pname = "alloydb-auth-proxy";
            version = inputs.alloydb-auth-proxy-src.shortRev or "unstable";
            src = inputs.alloydb-auth-proxy-src;
            vendorHash = "sha256-rxvy3G72IxMspdHMSFnd7pdb80520NZr/TKVAkAgPpA=";
            doCheck = false;
            meta.mainProgram = "alloydb-auth-proxy";
          };
        })
      ];

      macHomeModules = [
        ./modules/common.nix
        ./modules/darwin/home.nix
      ];
    in
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
            { nixpkgs.overlays = overlays; }
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = { username = "uncool"; inherit inputs; };
              home-manager.users.uncool = { ... }: {
                imports = macHomeModules;
                _module.args.username = "uncool";
              };
            }
          ];
        };

        homeConfigurations =
          let
            mkHome = { system, modules }:
              home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs { inherit system overlays; config.allowUnfree = true; };
                inherit modules;
                extraSpecialArgs = { username = "uncool"; inherit inputs; };
              };
          in {
            "uncool@mac"    = mkHome { system = "aarch64-darwin"; modules = macHomeModules; };
            "uncool@ubuntu" = mkHome { system = "x86_64-linux";   modules = [ ./modules/common.nix ./modules/ubuntu.nix ]; };
            "uncool@arch"   = mkHome { system = "x86_64-linux";   modules = [ ./modules/common.nix ./modules/arch.nix   ]; };
          };
      };
    };
}
