{pkgs, ...}: let
  zed_x_daemon = pkgs.zed_x_daemon;
  zed_x_driver = pkgs.zed_x_driver;
in {
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
  };
}
