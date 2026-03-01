{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../nixosModules/jetson
  ];

  networking.hostName = "SeaWolf9";
  systemd.network.networks."10-wired-tether".matchConfig.Name = "enP8p1s0";
  seawolf.tether.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  time.timeZone = "America/New_York";

  system.stateVersion = "24.11";
}
