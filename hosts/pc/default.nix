{ config, pkgs, ... }:

{
  imports = [
    ../../configuration.nix          # Configuración común
    ./hardware-configuration.nix     # Hardware exclusivo de esta PC
  ];

  networking.hostName = "pc";
  _module.args = { keyboardLayout = "us"; };
    environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "us";
  };
}

