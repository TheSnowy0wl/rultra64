{ pkgs, lib, inputs, ... }:

{
  networking.nftables.enable = true;

  networking.firewall.rejectPackets = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 25565 67 53 ];
    allowedTCPPorts = [ 25565 53 ];
    interfaces = {
      wg0 = {
        allowedTCPPorts = [ 22 ];
      };
    };
  };
}
