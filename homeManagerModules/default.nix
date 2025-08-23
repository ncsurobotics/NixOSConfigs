_: {
  imports = [
    ./shell
  ];

  programs = {
    eza.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
    ripgrep-all.enable = true;
  };

  home.stateVersion = "25.05";
}
