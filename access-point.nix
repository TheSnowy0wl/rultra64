{ pkgs, lib, inputs, ... }:

{
  networking.networkmanager.ensureProfiles.profiles = {
    rultra64ap = {
      connection = {
        autoconnect = "false";
        id = "rultra64ap";
        interface-name = "wlan0";
        type = "wifi";
        uuid = "c32dde1a-c09f-4ca9-8ccc-904db42a04b1";
      };
      ipv4 = {
        method = "shared";
        addresses = "192.168.10.1/24";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "ignore";
      };
      proxy = { };
      wifi = {
        mode = "ap";
        ssid = "rultra-64ap";
      };
      wifi-security = {
        group = "ccmp;";
        key-mgmt = "wpa-psk";
        pairwise = "ccmp;";
        proto = "rsn;";
        psk = "<WPA-PSK>";
      };
    };
  };

  systemd.services.access-point = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ]; # Use network-online.target instead of network.target to ensure the network is fully up.
    requires = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = ''${pkgs.networkmanager}/bin/nmcli connection up rultra64ap'';
    };
  };
}
