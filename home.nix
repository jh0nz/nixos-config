{ config, pkgs, inputs, pkgs-unstable, pkgs-master, ...}:

  # let
  #   lightpanda = import ./lightpanda.nix { inherit pkgs; };
  # in 
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
  	];

  programs.bash = {
		enable = true;
		shellAliases = {
			update  = "sudo nixos-rebuild switch";
		};
	};

  programs.git = {
    enable = true;
    userName = "jh0nz";
    userEmail = "jhondeycraft776@gmail.com";
    signing = {
      key = null;
      signByDefault = false;
    };
    settings = {
      init.defaultBranch = "main";
      core.autocrlf = "input";
      # SSH signing example (uncomment to use):
      # gpg.format = "ssh";
      # user.signingkey = "~/.ssh/id_ed25519.pub";
    };
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
      "*.log"
      "node_modules"
      ".env"
      "dist"
      "build"
    ];
  };

	services.syncthing = {
		enable = true;
		# package = pkgs.syncthing_2_0_15; # Optional, if you want to force the version
	};
	wayland.windowManager.hyprland = {
		enable = true;
		package = null;
		portalPackage = null;

		settings = {
			"$mod" = "SUPER";
			monitor = [
 				"eDP-1, preferred, auto,1"
			];
			exec-once = [
				"waybar"
				"hyprpaper"
				"mako"
			];

			input = {
				kb_layout = "latam";
				sensitivity = 0;
				touchpad = {
					natural_scroll = true;
				};
			};
			gesture = "3, horizontal, workspace";
			animations = {
				enabled = true;
				bezier = [
					"easeOutQuint, 0.23, 1, 0.32, 1"
					"easeInOutCubic, 0.65, 0.05, 0.36, 1"
					"linear, 0, 0, 1, 1"
					"almostLinear, 0.5, 0.5, 0.75, 1"
					"quick, 0.15, 0, 0.1, 1"
				];
				animation = [
					"global, 1, 10, default"
					"border, 1, 5.39, easeOutQuint"
					"windows, 1, 4.79, easeOutQuint"
					"windowsIn, 1, 4.1, easeOutQuint, popin 87%"
					"windowsOut, 1, 1.49, linear, popin 87%"
					"fadeIn, 1, 1.73, almostLinear"
					"fadeOut, 1, 1.46, almostLinear"
					"fade, 1, 3.03, quick"
					"layers, 1, 3.81, easeOutQuint"
					"layersIn, 1, 4, easeOutQuint, fade"
					"layersOut, 1, 1.5, linear, fade"
					"fadeLayersIn, 1, 1.79, almostLinear"
					"fadeLayersOut, 1, 1.39, almostLinear"
					"workspaces, 1, 1.94, almostLinear, fade"
					"workspacesIn, 1, 1.21, almostLinear, fade"
					"workspacesOut, 1, 1.94, almostLinear, fade"
					"zoomFactor, 1, 7, quick"
				];
			};
			general = {
				border_size = 1;
				gaps_in = 2;
				gaps_out = 2;
			};
			bind = [
				"$mod, W, killactive"
				"$mod, M, exit"
				"$mod, Space, exec, rofi -show drun"
				"$mod, Return, exec, ghostty"	
				"$mod, 1, workspace, 1"
				"$mod, 2, workspace, 2"
				"$mod, 3, workspace, 3"
				"$mod, 4, workspace, 4"
				"$mod, 5, workspace, 5"
				"$mod, 6, workspace, 6"
				"$mod, 7, workspace, 7"
				"$mod, 8, workspace, 8"
				"$mod, 9, workspace, 9"
				"$mod, 0, workspace, 10"

				"$mod SHIFT, 1, movetoworkspace, 1"
				"$mod SHIFT, 2, movetoworkspace, 2"
				"$mod SHIFT, 3, movetoworkspace, 3"
				"$mod SHIFT, 4, movetoworkspace, 4"
				"$mod SHIFT, 5, movetoworkspace, 5"
				"$mod SHIFT, 6, movetoworkspace, 6"
				"$mod SHIFT, 7, movetoworkspace, 7"
				"$mod SHIFT, 8, movetoworkspace, 8"
				"$mod SHIFT, 9, movetoworkspace, 9"
				"$mod SHIFT, 0, movetoworkspace, 10"

				"$mod, B, exec, thorium"
				"$mod SHIFT, R, exec, pkill waybar || waybar"
			];
			bindm = [
				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
			];
			bindl = [
				",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
				",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
				",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
				",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
				",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
			];
			env = [
				"XCURSOR_SIZE, 24"
				"QT_QPA_PLATFORM, wayland;xbc"
				
			];
		};
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

