# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, libs, pkgs, inputs, ... }:
{
  #hardware
  hardware.graphics.enable = true;
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = ["8286ac0e470f2f2f"];
security.polkit.enable = true;
security.rtkit.enable = true;
security.pam.services.login.enableGnomeKeyring = true;
services.gnome.gnome-keyring.enable = true;
virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };

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
	boot.supportedFilesystems = [ "ntfs" ];
xdg.portal.enable = true;
xdg.portal.config.common.default = "gnome;gtk;";
services.flatpak.enable = true;
        services.power-profiles-daemon.enable = true;

services.upower.enable = true;
services.xserver.videoDrivers = ["nvidia"];
virtualisation.docker.enable = true;
	hardware.nvidia = {
		open = true;
		powerManagement.enable = true;
		modesetting.enable = true;
		prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; 
      };
      
      intelBusId = "PCI:0:2:0";   
      nvidiaBusId = "PCI:1:0:0"; 
    };
	};
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

 programs.nix-ld.enable = true;
 programs.nix-ld.libraries = with pkgs; [
   stdenv.cc.cc
   zlib
 ];
 # boot.kernelParams = [
 #      "intel_iommu=on"           # CPU Intel (la mayoría de laptops con RTX)
 #      "iommu=pt"                 # Rendimiento
 #      "vfio-pci.ids=10de:2520,10de:228e"  # Tus IDs GPU + audio
 #    ];
 #
 #    boot.initrd.kernelModules = [
 #      "vfio_pci"
 #      "vfio"
 #      "vfio_iommu_type1"
 #    ];
 #    boot.blacklistedKernelModules = [
 #      "nvidia"
 #      "nvidia_drm"
 #      "nvidia_modeset"
 #      "nvidia_uvm"
 #      "nouveau"
  #    ];
  programs.niri.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
 
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
  services.libinput.enable = true;
   services.xserver.enable = true;
   services.xserver.displayManager.sessionCommands = ''
	slstatus &
   '';
   services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.override {
      patches = [
        # True fullscreen (not just monocle + hide bar)
        (pkgs.fetchpatch {
          url = "https://dwm.suckless.org/patches/actualfullscreen/dwm-actualfullscreen-20211013-cb3f58a.diff";
          hash = "sha256-vsTuudJCy7Zo1wdwpI/nY7Zu1txXx90QoDfJLmfDUH8=";
        })
        # All floating windows are centered automatically
        (pkgs.fetchpatch {
          url = "https://dwm.suckless.org/patches/alwayscenter/dwm-alwayscenter-20200625-f04cac6.diff";
          hash = "sha256-xQEwrNphaLOkhX3ER09sRPB3EEvxC73oNWMVkqo4iSY=";
        })
        # Hide tags with no clients on the bar (cleaner bar)
        (pkgs.fetchpatch {
          url = "https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.4.diff";
          hash = "sha256-GIbRW0Inwbp99rsKLfIDGvPwZ3pqihROMBp5vFlHx5Q=";
        })
	(pkgs.fetchpatch {
		url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.6.diff";
		hash = "sha256-fPg8z822OH0/Y0iqXyPc5JVTqEAZIMInKR4XUuDxgXQ="; 
	})
	./keybinds.patch
      ];
    };
  };
  services.displayManager.ly = {
    enable = true;
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
    layout = "us";
    variant = "";
  };

	  # Configure console keymap
  console.keyMap = "us";
	services.dbus.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jhon = {
    isNormalUser = true;
    description = "jhon";
    extraGroups = [ "libvirtd" "networkmanager" "wheel" "docker" "adbusers" "kvm" "video" "render"];
    packages = with pkgs; [];
  };

  # Create a greeter system user and group for display manager
  users.groups.greeter = {
    gid = 1001; # arbitrary unused GID, adjust if needed
  };

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    extraGroups = [ "video" ];
    description = "Display manager greeter user";
    createHome = false;
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
        kitty
        pciutils
        i3
        i3status
        dmenu
        st
	    virt-manager
    virtio-win     # Contiene las ISOs de controladores para Windows
    spice-gtk
    xdg-desktop-portal-gtk
    nautilus
    xdg-desktop-portal-gnome
    xwayland-satellite
    kdePackages.polkit-kde-agent-1
  ];
 nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
  allowedTCPPorts = [ 63342 53317 4321 7777 34197];
  # Si es para emparejar Android, a veces necesitas un rango
  allowedTCPPortRanges = [
    { from = 5555; to = 5585; }
  ];
allowedUDPPorts = [ 53317 34197];
};


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
	}
