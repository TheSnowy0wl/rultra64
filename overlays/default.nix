{ config, pkgs, lib, ...  }:

{
  nixpkgs.overlays = [
    (final: prev: {
      retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs {
        src = prev.fetchFromGitHub {
          owner = "TheSnowy0wl";
          repo = "retroarch-joypad-autoconfig";
          rev = "b265069a5b2af9d0e419a3984615e53627c6c8a2";
          hash = "sha256-AphVcss+bhBfanEJMm+sBq5LeBUVC2SKQpRpnZicEkU=";
        };
      };
    })
  ];
}
