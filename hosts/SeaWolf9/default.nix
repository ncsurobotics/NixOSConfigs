_: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "SeaWolf9";

  time.timeZone = "America/New_York";

  # system.stateVersion = "23.11";
}
