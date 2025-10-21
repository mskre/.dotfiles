{
  config,
  pkgs,
  lib,
  ...
}:

{
  users.users.mikkel = {
    isNormalUser = true;
    description = "mikkel";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "adbusers"
    ];
  };
}
