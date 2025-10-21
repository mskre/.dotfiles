nmcli con add \
  type wifi \
  ifname wlan0 \
  con-name eduroam \
  ssid eduroam \
  ipv4.method auto \
  802-1x.eap peap \
  802-1x.phase2-auth mschapv2 \
  802-1x.identity eliasse@uia.no \
  802-1x.password <passord> \
  wifi-sec.key-mgmt wpa-eap
