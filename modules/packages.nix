{
  unstable,
  pkgs,
  lib,
  ...
}:

let
  gst = pkgs.gst_all_1;
  # her lager vi en egen variant av taskwarrior3
  taskwarrior3-json = pkgs.taskwarrior3.override {
    withJson = true;
  };
in
{
  environment.systemPackages =
    with unstable;
    [
      pam_u2f
      quota
      libu2f-host
      pinentry-qt
      tcpdump
      gpgme
      openvpn
      audit
      openssl
      sops
      wpa_supplicant
      acpid
      age
      asusctl
      bluez
      bluez-tools
      docker
      efibootmgr
      flatpak
      gnome-keyring
      gnupg
      signal-desktop
      greetd
      keyd
      libinput
      linux-firmware
      networkmanager
      networkmanager-openvpn
      networkmanagerapplet
      patchelf
      pinentry
      wireguard-tools
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
