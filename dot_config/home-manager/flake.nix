{
  description = "Ananth's home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      username = "uncool";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/common.nix
          ./modules/shell.nix
          (if pkgs.stdenv.isDarwin then ./modules/darwin.nix else ./modules/linux.nix)
        ];
        extraSpecialArgs = { inherit username; };
      };
    };
}
