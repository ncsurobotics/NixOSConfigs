{ pkgs, ... }:
{
  services.mediamtx.enable = true;
  environment.systemPackages = with pkgs.gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];
}
