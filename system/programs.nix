{ config, pkgs, lib, inputs, ... }:

{
  programs.firefox.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.default;

  programs.nix-ld.enable = true;
  programs.hyprland.enable = true;
}
