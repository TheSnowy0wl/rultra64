{
  description = "Portable gaming emulator for RPI";
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
      nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
      hyprland.url = "github:hyprwm/Hyprland";
      home-manager = {
        url = "github:nix-community/home-manager/release-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs = { self, nixpkgs, nixos-raspberrypi, hyprland, home-manager }@inputs:
    {
      nixosConfigurations = {
         rultra64 = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            home-manager.nixosModules.default
            ./minecraft.nix
            ./access-point.nix
            ./wireguard.nix
            ./firewall.nix
            (import ./overlays)
            ({...}: {
              imports = with nixos-raspberrypi.nixosModules; [
                raspberry-pi-5.base
                raspberry-pi-5.bluetooth
                raspberry-pi-5.display-vc4
              ];
            })
            ({ pkgs, lib, ... }: {

              system.stateVersion= "25.05";
              
              nixpkgs.config.allowUnfree = true;
              networking.hostName = "rultra64";
	      users.mutableUsers = true;
              users.users.gamemaster = {
                initialPassword = "gamemaster";
                isNormalUser = true;
                extraGroups = [
                  "wheel"
                  "networkmanager"
                ];
              };

              networking.networkmanager.enable = true;

              environment.systemPackages = with pkgs; [ 
                wireguard-tools
                iw
                pciutils 
                lshw 
                vim 
                alacritty 
                wget 
                pavucontrol 
                git 
                hostapd 
                dnsmasq 
                bridge-utils 
		        (retroarch.withCores (cores: with cores; [ mupen64plus dolphin  ]))
		      ]; 

              nix.settings.experimental-features = [ "nix-command"  "flakes" ]; 


              security.polkit.enable = true;

              services.greetd = {
                enable = true;
                vt = 2;
                settings = {
                  default_session = {
                    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
                    user = "gamemaster";
                  };
                };
              };


              programs.gamemode.enable = true;


              services.haveged.enable = true;

              security.rtkit.enable = true;
              services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
              };

              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                    users = {
                      "gamemaster" = import ./home.nix;
                      };      
                };

              boot.consoleLogLevel = 3;

              services.openssh = {
                enable = true;
                openFirewall = false;
                settings = {
                  PasswordAuthentication = false;
                };
                listenAddresses = [
                  {
                    addr = "10.10.0.1";
                    port = 22;
                  }
                ];
              };

              hardware.bluetooth = {
                enable = true;
                powerOnBoot = true;
              };

              
              systemd.services.sshd.after = [ "wg-quick-wg0.service" ];

              users.users.gamemaster.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXMmPOX7MwDXgCfZnQJMVoaEhN1on5ggxaXkIGBOinx thesnowyowl@theowlnest" ];
            
            })

            ({ ... }: {
              fileSystems = {
                "/boot/firmware" = {
                  device = "/dev/disk/by-uuid/2175-794E";
                  fsType = "vfat";
                  options = [
                    "noatime"
                    "noauto"
                    "x-systemd.automount"
                    "x-systemd.idle-timeout=1min"
                  ];
                };
                "/" = {
                  device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
                  fsType = "ext4";
                  options = [ "noatime" ];
                };
              };
            })
          ];
        };
      };
    };
}
