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
        ];
      }
    );
in
{
  flake.nixosConfigurations = mkNixosConfigurations [
    "SeaWolf9"
  ];
}
