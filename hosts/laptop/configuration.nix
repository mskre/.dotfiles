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
    ../../configuration.nix
    ../../modules/packages.nix
    ../../modules/users.nix
    ../../system/boot.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ overlay-tmux-master ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs unstable; };
    users.mikkel = import ./home.nix;
  };

  # OLD
  security.pam.services.swaylock = { };

  programs.zsh.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;

  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  hardware.pulseaudio.package = pkgs.pulseaudio;
  hardware.pulseaudio.extraConfig = ''
    load-module module-bluetooth-discover
    load-module module-switch-on-connect
  '';

  users.users.mikkel.extraGroups = [ "input" ];

  programs.firefox.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.default;

  networking.extraHosts = ''
    10.225.148.107 origin.ikt211
    10.20.16.12 nimbus.ikt211
    10.20.16.12 support.nimbus.ikt211
    10.20.16.12 proxy.nimbus.ikt211
    10.20.16.12 messages.nimbus.ikt211
    10.20.16.12 kb.nimbus.ikt211
    10.20.16.12 knowledgebase.nimbus.ikt211
    10.20.16.12 jobs.nimbus.ikt211
    10.20.16.11 admin.nimbus.ikt211
    10.20.16.12 incident.nimbus.ikt211
  '';

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;
  programs.hyprland.enable = true;

  services.flatpak.enable = true;
  systemd.packages = [ pkgs.flatpak ];

  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:75:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.supergfxd = {
    enable = true;
    settings = {
      nvidia_powerd = false;
    };
  };

  services.gnome.gnome-keyring.enable = true;

  virtualisation.docker.enable = true;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
