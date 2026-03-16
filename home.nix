{ config, pkgs, inputs, pkgs-unstable, pkgs-master, ...}:

  # let
  #   lightpanda = import ./lightpanda.nix { inherit pkgs; };
  # in 
  imports = [
    ./hyprland.nix
  ];
{
	home.username = "jhon";
	home.homeDirectory = "/home/jhon";
	home.packages = with pkgs; [
		waybar
		ghostty
		rofi
		hyprpaper
		inputs.thorium.packages.${pkgs.stdenv.hostPlatform.system}.thorium-avx2
		pkgs-master.opencode
		mako
  		pkgs-master.obsidian
  		syncthing
  		pkgs-unstable.jetbrains.idea
		pkgs-master.vesktop
		pkgs-master.wiremix
		pkgs-master.parsec-bin
		pkgs-master.firefox
		pkgs-master.gh
		pkgs-master.lazygit
  	];

  programs.bash = {
		enable = true;
		shellAliases = {
			update  = "sudo nixos-rebuild switch";
			garbage = "nix-collect-garbage -d";
		};
	};
	programs.git = {
    		enable = true;
    		settings = {
			init.defaultBranch = "main";
			user.name = "jh0nz";
			user.email = "jhondeycraft776@gmail.com";
    		};
	};

	services.syncthing = {
		enable = true;
		# package = pkgs.syncthing_2_0_15; # Optional, if you want to force the version
	};
	home.pointerCursor = {
		gtk.enable = true;
		package = pkgs.bibata-cursors;
		name = "Bibata-Modern-Classic";
		size = 24;

	};

	home.stateVersion = "25.11";
	

  programs.waybar.enable = true;
  # programs.waybar.settings = {
  #   mainBar = {
  #     height = 30;
  #     spacing = 4;
  #     "modules-left" = [
  #       "sway/workspaces"
  #       "sway/mode"
  #       "sway/scratchpad"
  #       "custom/media"
  #     ];
  #     "modules-center" = [ "sway/window" ];
  #     "modules-right" = [
  #       "mpd"
  #       "idle_inhibitor"
  #       "pulseaudio"
  #       "network"
  #       "power-profiles-daemon"
  #       "cpu"
  #       "memory"
  #       "temperature"
  #       "backlight"
  #       "keyboard-state"
  #       "sway/language"
  #       "battery"
  #       "battery#bat2"
  #       "clock"
  #       "tray"
  #       "custom/power"
  #     ];
  #     "keyboard-state" = {
  #       numlock = true;
  #       capslock = true;
  #       format = "{name} {icon}";
  #       "format-icons" = {
  #         locked = "";
  #         unlocked = "";
  #       };
  #     };
  #     "sway/mode".format = "<span style=\"italic\">{}</span>";
  #     "sway/scratchpad" = {
  #       format = "{icon} {count}";
  #       show-empty = false;
  #       "format-icons" = [ "" "" ];
  #       tooltip = true;
  #       "tooltip-format" = "{app}: {title}";
  #     };
  #     mpd = {
  #       format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
  #       "format-disconnected" = "Disconnected ";
  #       "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
  #       "unknown-tag" = "N/A";
  #       interval = 5;
  #       "consume-icons".on = " ";
  #       "random-icons" = {
  #         off = "<span color=\"#f53c3c\"></span> ";
  #         on = " ";
  #       };
  #       "repeat-icons".on = " ";
  #       "single-icons".on = "1 ";
  #       "state-icons" = {
  #         paused = "";
  #         playing = "";
  #       };
  #       "tooltip-format" = "MPD (connected)";
  #       "tooltip-format-disconnected" = "MPD (disconnected)";
  #     };
  #     "idle_inhibitor" = {
  #       format = "{icon}";
  #       "format-icons" = {
  #         activated = "";
  #         deactivated = "";
  #       };
  #     };
  #     tray = {
  #       spacing = 10;
  #     };
  #     clock = {
  #       "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
  #       "format-alt" = "{:%Y-%m-%d}";
  #     };
  #     cpu = {
  #       format = "{usage}% ";
  #       tooltip = false;
  #     };
  #     memory.format = "{}% ";
  #     temperature = {
  #       "critical-threshold" = 80;
  #       format = "{temperatureC}°C {icon}";
  #       "format-icons" = [ "" "" "" ];
  #     };
  #     backlight = {
  #       format = "{percent}% {icon}";
  #       "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
  #     };
  #     battery = {
  #       states = {
  #         warning = 30;
  #         critical = 15;
  #       };
  #       format = "{capacity}% {icon}";
  #       "format-full" = "{capacity}% {icon}";
  #       "format-charging" = "{capacity}% ";
  #       "format-plugged" = "{capacity}% ";
  #       "format-alt" = "{time} {icon}";
  #       "format-icons" = [ "" "" "" "" "" ];
  #     };
  #     "battery#bat2" = {
  #       bat = "BAT2";
  #     };
  #     "power-profiles-daemon" = {
  #       format = "{icon}";
  #       "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
  #       tooltip = true;
  #       "format-icons" = {
  #         default = "";
  #         performance = "";
  #         balanced = "";
  #         "power-saver" = "";
  #       };
  #     };
  #     network = {
  #       "format-wifi" = "{essid} ({signalStrength}%) ";
  #       "format-ethernet" = "{ipaddr}/{cidr} ";
  #       "tooltip-format" = "{ifname} via {gwaddr} ";
  #       "format-linked" = "{ifname} (No IP) ";
  #       "format-disconnected" = "Disconnected ⚠";
  #       "format-alt" = "{ifname}: {ipaddr}/{cidr}";
  #     };
  #     pulseaudio = {
  #       format = "{volume}% {icon} {format_source}";
  #       "format-bluetooth" = "{volume}% {icon} {format_source}";
  #       "format-bluetooth-muted" = " {icon} {format_source}";
  #       "format-muted" = " {format_source}";
  #       "format-source" = "{volume}% ";
  #       "format-source-muted" = "";
  #       "format-icons" = {
  #         headphone = "";
  #         "hands-free" = "";
  #         headset = "";
  #         phone = "";
  #         portable = "";
  #         car = "";
  #         default = [ "" "" "" ];
  #       };
  #       "on-click" = "pavucontrol";
  #     };
  #     "custom/media" = {
  #       format = "{icon} {text}";
  #       "return-type" = "json";
  #       "max-length" = 40;
  #       "format-icons" = {
  #         spotify = "";
  #         default = "🎜";
  #       };
  #       escape = true;
  #       exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
  #     };
  #     "custom/power" = {
  #       format = "⏻ ";
  #       tooltip = false;
  #       menu = "on-click";
  #       "menu-file" = "$HOME/.config/waybar/power_menu.xml";
  #       "menu-actions" = {
  #         shutdown = "shutdown";
  #         reboot = "reboot";
  #         suspend = "systemctl suspend";
  #         hibernate = "systemctl hibernate";
  #       };
  #     };
  #   };
  # };
}

