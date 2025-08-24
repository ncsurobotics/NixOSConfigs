_: {
  programs = {
    zellij = {
      enable = true;
      attachExistingSession = true;
      exitShellOnExit = true;
      enableFishIntegration = true;
    };
    tmux.enable = true;
  };
}
