{ inputs, ... }:
{
  imports = [
    ./nh.nix
    ./substituters.nix
  ];

  nix = {
    # Pin registry to currrent nixpkgs version
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Optimize storage
      auto-optimise-store = true;
    };
  };
}
