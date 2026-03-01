{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../nixosModules/desktopEnvironment
  ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
    };
  };

  # Loads the driver for Xorg AND Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];
    
  services.pipewire = {
    enable = true;
    wireplumber.extraConfig."10-disable-camera" = {
      "wireplumber.profiles" = {
        main."monitor.libcamera" = "disabled";
      };
    };
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;

  hardware.nvidia.prime = {
    sync.enable = true;
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services = {
    fwupd.enable = true;
    blueman.enable = true;
    tailscale.authKeyFile = "/persist/secrets/tailscaleAuthKey";
  };

  networking.hostName = "Constantinople";

  systemd.network.networks."20-main".matchConfig.Name = "wlan0";

  time.timeZone = "America/New_York";

  services.openssh.vpnAccess = {
    enable = true;
    interface = "tailscale0";
  };

  services.upower.enable = true;
  security.rtkit.enable = true;
  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    # Enable systemd in phase 1. Used for unlocking root partition with FIDO2/TPM
    initrd.systemd.enable = true;
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        # Limit the number of generations to keep
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };
    
  system.stateVersion = "24.11";
}
