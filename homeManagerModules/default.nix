_: {
  imports = [
    ./shell
  ];

  programs = {
    eza.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
    ripgrep-all.enable = true;
    yazi = {
      enable = true;
      shellWrapperName = "y";
      settings = {
        mgr = {
          show_hidden = true;
          sort_dir_first = true;
          sort_by = "mtime";
          sort_reverse = true;
        };
      };
    };
  };

  home.stateVersion = "25.05";
}
