{
  inputs,
  ...
}:
{
  imports = [ inputs.jetpack-nixos.nixosModules.default ];

  hardware.nvidia-jetpack = {
    enable = true;
    carrierBoard = "devkit";
    som = "orin-nano";
    # super = true;
  };
}
