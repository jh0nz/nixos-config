{ config, pkgs, ... }:

{
  imports = [
    ../../configuration.nix          # Configuración común
    ./hardware-configuration.nix     # Hardware exclusivo de esta PC
  ];

  networking.hostName = "pc";
}

