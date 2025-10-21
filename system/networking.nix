{
  config,
  pkgs,
  lib,
  ...
}:

{

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

  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ 51820 ];
  };

}
