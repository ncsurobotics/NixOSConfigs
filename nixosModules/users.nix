_: {
  users = {
    mutableUsers = false;
    users.aqua = {
      hashedPasswordFile = "/persist/secrets/aqua-passwd";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "plugdev"
        "dialout"
      ];
    };
  };
}
