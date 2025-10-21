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
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./laptop.conf;
    "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
