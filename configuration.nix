# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, libs, pkgs, inputs, pkgs-unstable, ... }:
let
	username = "jhon";
	hyprlandCmd = "${pkgs.hyprland}/bin/Hyprland";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  #hardware
  hardware.graphics.enable = true;
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = ["8286ac0e470f2f2f"];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
	services.power-profiles-daemon.enable = true; 
  services.xserver.videoDrivers = ["nvidia"];
virtualisation.docker.enable = true;
	hardware.nvidia = {
		open = true;
		modesetting.enable = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 programs.nix-ld.enable = true;
 programs.nix-ld.libraries = with pkgs; [
   stdenv.cc.cc
   zlib
   # Agrega aquí otras librerías si ldd indica que faltan
 ];	
	programs.hyprland.enable = true;

  # Use linux kernel 6.18 from unstable.
  boot.kernelPackages = pkgs-unstable.linuxPackages_6_18;
 
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	nix.settings = {
		substituters = ["https://hyprland.cachix.org"];
		trusted-substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-a:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
	};
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
	programs.steam = {
		enable = true;
		localNetworkGameTransfers.openFirewall = true;
	};
	hardware.graphics.enable32Bit= true;
  # Enable networking
  networking.networkmanager.enable = true;
	services.greetd = {
		enable = true;
		restart = false;
		settings = {
			initial_session = {
				command = hyprlandCmd;
				user = username;
			};
			default_session = {
				command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
				user = "greeter";
			};
		};
	};
	systemd.services."getty@tty1".enable = false;
	systemd.services."autovt@tty1".enable = false;
	fonts.packages = with pkgs; [
  		nerd-fonts.jetbrains-mono
	];
  # Set your time zone.
  time.timeZone = "America/La_Paz";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_BO.UTF-8";
    LC_IDENTIFICATION = "es_BO.UTF-8";
    LC_MEASUREMENT = "es_BO.UTF-8";
    LC_MONETARY = "es_BO.UTF-8";
    LC_NAME = "es_BO.UTF-8";
    LC_NUMERIC = "es_BO.UTF-8";
    LC_PAPER = "es_BO.UTF-8";
    LC_TELEPHONE = "es_BO.UTF-8";
    LC_TIME = "es_BO.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jhon = {
    isNormalUser = true;
    description = "jhon";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "kvm" ];
    packages = with pkgs; [];
  };

  users.users.greeter = {
	isSystemUser = true;
	group = "greeter";
	extraGroups = ["video" ]; 
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  environment.systemPackages = with pkgs; [
  neovim
	wget
	git
	brightnessctl
	fastfetch
	zerotierone
	android-tools
	ngrok
  ];
 nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
networking.firewall = {
  enable = true;
  # Abre el puerto del servidor interno de IntelliJ
  allowedTCPPorts = [ 63342 ];
  # Si es para emparejar Android, a veces necesitas un rango
  allowedTCPPortRanges = [
    { from = 5555; to = 5585; }
  ];
};
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
