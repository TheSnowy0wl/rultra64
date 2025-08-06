{ pkgs, lib, inputs, ... }:

{
  networking.wg-quick.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
      address = [ "10.10.0.1/24" ];
      # The port that WireGuard listens to - recommended that this be changed from default
      listenPort = 51820;
      # Path to the server's private key
      privateKeyFile = "<PRIVATE-KEY-FILE>";

      peers = [
        { # laptop
          publicKey = "<PUB-KEY>";
          allowedIPs = [ "10.10.0.2/32" ];
        }
      ];
    };
  };
}
