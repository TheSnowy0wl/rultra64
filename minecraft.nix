{ pkgs, lib, inputs, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    serverProperties = {
        gamemode = "survival";
        difficulty = "hard";
        online-mode = "false";
        level-seed = "defcon2025";
        motd = "Rultra64 Defcon 2025 Minecraft Server";
        rate-limit = "5000";
        snooper-enabled = "false";
        enable-query = "true";
     };
   };
}
