{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
in
{
  home-manager.users.mikkel.xdg.configFile = {
    "hypr/hyprland.conf".source = ./desktop.conf;
    "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
