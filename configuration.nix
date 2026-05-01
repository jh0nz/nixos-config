# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, libs, pkgs, inputs, pkgs-unstable, ... }:
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
  pulse.enable = true;
  wireplumber.extraConfig."99-disable-agc" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "~alsa_input.*";
          }
        ];
        actions = {
          "update-props" = {
            "capture.auto_gain_control" = false;
          };
        };
      }
    ];
  };
  extraConfig.pipewire-pulse."99-no-agc" = {
    "pulse.rules" = [
      {
        matches = [ { "application.name" = "~.*"; } ];
        actions = {
          quirks = [ "block-source-volume" ];
        };
      }
    ];
  };
};
hardware.bluetooth.enable = true;
hardware.bluetooth.powerOnBoot = true;

        services.printing = {
          enable = true;
          drivers = with pkgs; [ gutenprint ];
        };
services.samba = {
  enable = true;
  openFirewall = true;
  settings = {
    global = {
      "workgroup" = "WORKGROUP";
      "server string" = "NixOS Samba";
      "security" = "user";
      "client min protocol" = "SMB2";
      "client max protocol" = "SMB3";
    };
  };
};
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};
xdg.portal = {
  enable = true;
  xdgOpenUsePortal = true;
  extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
  ];
  config = {
    common.default = [ "gnome" ];
    niri = {
      default = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    };
  };
};

        services.power-profiles-daemon.enable = true;

services.upower.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
virtualisation.docker.enable = true;
	hardware.nvidia = {
		open = true;
                powerManagement.enable = true;
		modesetting.enable = true;
		package = config.boot.kernelPackages.nvidiaPackages.latest;
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
#programs.hyprland.enable = true;
        programs.niri.enable = true;
  # Use linux kernel 6.18 from unstable.
  boot.kernelPackages = pkgs-unstable.linuxPackages_latest;
 
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
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
	networking.networkmanager.wifi.powersave = false;
        networking.wireless.iwd.enable = true;
        networking.networkmanager.wifi.backend = "iwd";
        services.greetd = {
		enable = true;
		restart = false;
                settings = {
			default_session = {
				command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
				user = "greeter";
			};
        initial_session = {
                # Run the session under dbus-run-session and export the
                # session environment into systemd so graphical-session.target
                # and user services (like xdg-desktop-portal-gnome) work.
                command = ''
                  ${pkgs.dbus}/bin/dbus-run-session -- ${pkgs.bash}/bin/bash -c '
                    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE;
                    exec ${pkgs.niri}/bin/niri --session
                  '
                '';
                user = "jhon";
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
        xwayland-satellite
        kitty
  ];
 nix.settings.experimental-features = [ "nix-command" "flakes" ];

environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
  XDG_CURRENT_DESKTOP = "niri";
  XDG_SESSION_TYPE = "wayland";
  XDG_SESSION_DESKTOP = "niri";
};

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
  allowedTCPPorts = [ 63342 53317 ];
  # Si es para emparejar Android, a veces necesitas un rango
  allowedTCPPortRanges = [
    { from = 5555; to = 5585; }
  ];
allowedUDPPorts = [ 53317 ];
};


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
