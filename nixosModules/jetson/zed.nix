{lib, pkgs, inputs, ...}: let
  inherit (lib) getExe';
  driver_pkg = inputs.self.packages.${pkgs.system}.zed-link-mono-driver;
  zed_x_daemon = getExe' driver_pkg "ZEDX_Daemon";
  zed_x_driver = getExe' driver_pkg "ZEDX_Driver";
in {
  nixpkgs.overlays = [
    (final: prev: {
      nvidia-jetpack = prev.nvidia-jetpack.overrideScope (jfinal: jprev: {
        l4t-camera = jprev.l4t-camera.overrideAttrs (old: {
          postPatch = old.postPatch + ''
            ln -sfnt lib/ ${driver_pkg}/lib/aarch64-linux-gnu/tegra/libnvisppg.so
          '';
        });
      });
    })
  ];
  # hardware.deviceTree.overlays = [
  #   rec {
  #     name = "tegra234-p3768-camera-zedlink-mono-sl-overlay";
  #     dtboFile = driver_pkg + "/boot/${name}.dtbo";
  #   }
  # ];

  hardware.nvidia-jetpack.flashScriptOverrides.additionalDtbOverlays = [
    "${driver_pkg}/boot/tegra234-p3768-camera-zedlink-mono-sl-overlay.dtbo"
  ];

  system.activationScripts.zedLib.text = ''
    ln -sfnt /usr/ ${driver_pkg}/usr/lib/
  '';

  systemd.services = {
    zed_x_daemon = {
      unitConfig = {
        Description = "ZED-X Daemon service";
        After = [
          "nvargus-daemon.service"
          "driver_zed_loader.service"
        ];
        Requires = [ "driver_zed_loader.service" ];
        StartLimitIntervalSec = 0;
      };

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
        User = "root";
        StandardOutput = "syslog";
        ExecStart = zed_x_daemon;

        # 0 = no sync(Default), 1 = master/slave mode, 2 = slave mode only
        sync_mode = 0;
      };

      wantedBy = [ "multi-user.target" ];
    };

    driver_zed_loader = {
      unitConfig = {
        Description = "ZED-X Daemon service";
        After = [ "nvargus-daemon.service" ];
        StartLimitIntervalSec = 0;
      };

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        StandardOutput = "syslog";
        ExecStart = zed_x_driver;
      };

      wantedBy = [ "multi-user.target" ];
    };

    nvargus-daemon.serviceConfig.Environment = [ "enableCamInfiniteTimeout=1" ]; 
  };
}
