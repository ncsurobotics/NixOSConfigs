# NixOS Configurations
## Installation on an Nvidia Jetson Orin Nano
1. Flash UEFI firmware with Jetpack 6 support. See (jetpack-nixos)[https://github.com/anduril/jetpack-nixos/?tab=readme-ov-file#flashing-uefi-firmware]
2. Create installation media
  1. Build the customized installer iso. See (jetpack-nixos)[https://github.com/anduril/jetpack-nixos/?tab=readme-ov-file#installation-iso]
  2. Write the iso to a usb drive
3. Boot the installation media
4. Connect to the network
  ```bash
  wpa_cli
  add_network
  set_network 0 ssid "SSID"
  set_network 0 key_mgmt NONE 
  ```
5. Clone this repo
6. Partition the disk (Each hosts `disk-config.nix` is located in hosts/<host name>/): `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount <path to disk-config.nix>`
7. Install nixos: `nixos-install --root /mnt --flake <path to this repo>#<host name>`
