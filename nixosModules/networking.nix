_: {
  networking = {
    useNetworkd = true;
    nftables.enable = true;
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
      };
    };
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
      "8.8.8.8"
    ];
  };

  # Required by IWD to decrypt 802.1x EAP-TLS TLS client keys
  boot.kernelModules = [ "pkcs8_key_parser" ];

  systemd.network = {
    enable = true;
    networks."10-wired-tether" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = "192.168.2.5";
        DHCPServer = "yes";
      };
      dhcpServerConfig.PersistLeases = "no";
    };
  };

  services.resolved.enable = true;
}
