{
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem genAttrs;

  mkNixosConfigurations =
    hosts:
    genAttrs hosts (
      host:
      nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./${host}
          ../nixosModules
          inputs.disko.nixosModules.disko
        ];
      }
    );
in
{
  flake.nixosConfigurations = mkNixosConfigurations [
    "SeaWolf9"
  ];
}
