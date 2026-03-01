{
  inputs,
  ...
}:
{
  imports = [ inputs.jetpack-nixos.nixosModules.default ];

  hardware = {
    graphics.enable = true;
    nvidia-jetpack = {
      enable = true;
      carrierBoard = "devkit";
      som = "orin-nano";
      # super = true;
    };
  };
}
