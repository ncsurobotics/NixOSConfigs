_:
let
  commonSubvolMountOptions = [
    "compress=zstd"
    "noatime"
  ];
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/mmc-USD00_0x742f007e";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "--force" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = commonSubvolMountOptions;
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = commonSubvolMountOptions;
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = commonSubvolMountOptions;
                  };
                  "/var" = {
                    mountpoint = "/var";
                    mountOptions = commonSubvolMountOptions;
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = commonSubvolMountOptions;
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
