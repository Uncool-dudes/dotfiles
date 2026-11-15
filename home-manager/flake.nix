{
  description = "Ananth's home-manager configuration";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
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
    # Not following nixpkgs: the module pins the determinate-nixd build it ships.
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    flake-parts.url = "github:hercules-ci/flake-parts";
    llm-agents.url = "github:numtide/llm-agents.nix";
    # Not following nixpkgs here on purpose - its own locked nixpkgs is what
    # the cached aarch64-darwin build was built against; following ours would
    # likely turn that cache hit back into a from-source build.
    atuin.url = "github:atuinsh/atuin";
    loadout = {
      url = "github:Uncool-dudes/loadout";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plain sources, not flakes: tracked here so `nix flake update` bumps them
    # with everything else. Pin one on purpose by putting a rev/tag in its URL.
    claude-plugins-official = {
      url = "github:anthropics/claude-plugins-official";
      flake = false;
    };
    yazi-rs-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    wumpus-mono = {
      url = "github:vaughantype/wumpus-mono";
      flake = false;
    };
  };

  outputs =
    inputs@{
      flake-parts,
      home-manager,
      nix-darwin,
      stylix,
      ...
    }:
    let
      overlays = [
        # nixpkgs-unstable lags go.dev releases by weeks (source-build + channel
        # promotion gate). go_1_27 is already merged and cached on nixpkgs master.
        (final: prev: {
          go = (import inputs.nixpkgs-master { system = prev.stdenv.hostPlatform.system; }).go_1_27;
        })
      ];

      roles = {
        core = ./modules/roles/core.nix;
        dev = ./modules/roles/dev.nix;
        ai = ./modules/roles/ai.nix;
        infra = ./modules/roles/infra.nix;
        secrets = ./modules/roles/secrets.nix;
        extras = ./modules/roles/extras.nix;
        academia = ./modules/roles/academia.nix;
        darwinDesktop = ./modules/roles/darwin-desktop.nix;
      };

      commonRoles = with roles; [
        core
        dev
        ai
        infra
        secrets
        extras
        academia
      ];

      macHomeModules = [
        ./modules/base.nix
        ./modules/darwin/home.nix
      ]
      ++ commonRoles
      ++ [ roles.darwinDesktop ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.home-manager ];
        };
      };

      flake = {
        # System only. The user environment is the standalone
        # homeConfigurations."uncool@mac" (hms): no sudo, faster switches, and
        # one owner for dotfiles instead of two generations overwriting each other.
        darwinConfigurations."Ananths-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            inputs.determinate.darwinModules.default
            ./modules/darwin
            {
              nixpkgs.hostPlatform = "aarch64-darwin";
              nixpkgs.overlays = overlays;
            }
          ];
        };

        homeConfigurations =
          let
            mkHome =
              { system, modules }:
              home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs {
                  inherit system overlays;
                  config.allowUnfree = true;
                };
                inherit modules;
                extraSpecialArgs = {
                  username = "uncool";
                  inherit inputs;
                };
              };
          in
          {
            "uncool@mac" = mkHome {
              system = "aarch64-darwin";
              modules = macHomeModules;
            };
            "uncool@ubuntu" = mkHome {
              system = "x86_64-linux";
              modules = [ ./modules/base.nix ] ++ commonRoles ++ [ ./modules/ubuntu.nix ];
            };
            "uncool@arch" = mkHome {
              system = "x86_64-linux";
              modules = [ ./modules/base.nix ] ++ commonRoles ++ [ ./modules/arch.nix ];
            };
          };
      };
    };
}
