{
  description = "NixOS configurations for SeaWolves";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    flake-parts.url = "github:hercules-ci/flake-parts";

    jetpack-nixos = {
      url = "git+ssh://git@github.com/ncsurobotics/jetpack-nixos.git";
      inputs.nixpkgs.follows = "nixpkgs";      
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts
      ];
      systems = [ "aarch64-linux" ];
      perSystem =
        { pkgs, system, ... }:
        {
          packages.zed-link-mono-driver = pkgs.callPackage ./pkgs/zed-link-mono-driver.nix { jetpack = inputs.jetpack-nixos.legacyPackages.${system}.nvidia-jetpack6; };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nil
              just
              statix
              deadnix
            ];
          };
          formatter = pkgs.nixfmt-tree;
        };
      
    };
}
