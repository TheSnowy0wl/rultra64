# Rultra64

Rultra64 is a basic game emulator and minecraft server access point, built declaratively using NixOS on an RPI5.

## RPI support
Support for installing NixOS on an RPI can be found here:

This is what I followed to create a bootable RPI5 image for NixOS: https://github.com/nvmd/nixos-raspberrypi/tree/develop


## NixOS Configs

`flake.nix` <- contains the main flake as well as some core functions of the rpi.  

`access-point.nix` <- creates the rultra-64ap wifi access point on 192.168.10.1 as the AP address.  Leverages network manager to accomplish this.  You can attempt to swap out the WPA2 config with WPA3, but I didn't have much success trying this. 

`firewall.nix` <- Sets up the nftables firewall.  Currently the only allowed ports are for wireguard, the minecraft server, and DNS.  All other connections are dropped.  NOTE: Packets are rejected, this is on purpose as I want to log any refused connections just for curiosity.  For a best secured system its recommended this is turned off to make port scanning more difficult. SSH is also allowed exclusively on the wireguard interface.

`home.nix` <- Home manager module for setting up and configuring sway and zsh.  Alot of the configs could probably be moved here if you prefer it to be user specific to "gamemaster" vs system-wide.

`minecraft.nix` <- Sets up the minecraft server which runs.  By default it runs on online-mode = false since its intended that this server is not connected to the internet.  For a real server exposed to the internet TURN THIS SETTING TO TRUE OR REMOVE IT.  Without this anyone can connect to the server with an un-authenticated account, unless you prefer it that way.

`wireguard.nix` <- Sets up the wireguard VPN server to allow SSH admin access to the device.  Make sure you add any peers public keys that you wish to have access, and you will need to generate the private key files and point to them in the config.

`overlays` <- Contains a default.nix file which provides an overlay to overwrite the retroarch controller profiles.  Useful to help map controllers as by default the nix retroarch package places them in a read-only location.  This means if you want to update a controller profile you will need to fork the repo it points to, change your config, and then update the default.nix file to point to the new repo and commit hash.


## Setup

There are a number of secrets that need to be added to setup the device.  If you for this repo, DONT BE STUPID AND PUSH THOSE CHANGES UP TO GITHUB :).

 - WPA2 Passkey in `access-point.nix`
 - Private key file location in `wireguard.nix` (you must manually generate the private key using the wireguard utilities).
 - Public keys for peers in `wireguard.nix`
 - Remember to change the default password from `gamemaster` after first booting.
 - Update the authorized SSH keys in `flake.nix` to the keys you want there to be access for on the device.
