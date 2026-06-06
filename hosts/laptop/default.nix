{ config, pkgs, ... }:

{
  imports = [
    ../../configuration.nix          # Configuración común
    ./hardware-configuration.nix     # Hardware exclusivo de esta PC
  ];

  networking.hostName = "laptop";
  _module.args = { tecladoLayout = "latam"; };
    environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "latam";
  };
}

