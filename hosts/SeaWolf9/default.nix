{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  networking.hostName = "SeaWolf9";
  systemd.network.networks."10-wired-tether".matchConfig.Name = "enP8p1s0";
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  
  environment.systemPackages = with pkgs; [
    helix
    vim
    git
  ];

  time.timeZone = "America/New_York";

  system.stateVersion = "24.11";
}
