{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.flatpak.enable = true;
  systemd.packages = [ pkgs.flatpak ];

  virtualisation.docker.enable = true;
}
