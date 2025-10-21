{ config, pkgs, lib, ... }:

{
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.mikkel.extraGroups = [ "input" ];
}
