_: {
  imports = [
    ./git.nix
    ./helix.nix
    ./ssh-forward-agent.nix
  ];

  programs = {
    foot.enable = true;
    mpv.enable = true;
  };
}
