{
  config,
  pkgs,
  lib,
  unstable,
  inputs,
  ...
}:
let
  overlay-tmux-master = final: prev: {
    tmux = prev.tmux.overrideAttrs (_: {
      version = "git-master";
      src = inputs.tmux;
    });
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix

    ../../modules/packages.nix
    ../../modules/users.nix
    ../../system/boot.nix
    ../../system/hardware.nix
    ../../system/locale-users.nix
    ../../system/networking.nix
    ../../system/programs.nix
    ../../system/services.nix

    ../../home/mikkel/configurations/hyprland/desktop.nix
  ];

  security.pam.services.swaylock = { };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ overlay-tmux-master ];
  };

  home-manager.users = {
    mikkel = (import ../../home);
  };

  services.gnome.gnome-keyring.enable = true;

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;

  networking.hostName = "desktop"; # Define your hostname.
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;

  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  services.printing.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
