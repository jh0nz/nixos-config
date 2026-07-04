{ config, pkgs, inputs, pkgs-master, ...}:
let
  miWallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/8g/wallhaven-8gkdy2.jpg";
    hash = "sha256-N+o/0Fuzxx259N/aCVFA9e7lyiEe78qP2LJC1aYvrxc=";
  };
in
{
  imports = [
  ];
	home.username = "jhon";
	home.homeDirectory = "/home/jhon";
	home.packages = with pkgs; [
		noctalia-shell
                alacritty
		ghostty
		rofi
		# inputs.shapez-ce.outputs.packages.${pkgs.stdenv.hostPlatform.system}.default
		inputs.gamevox.outputs.packages.${pkgs.stdenv.hostPlatform.system}.default
		mako
	   	syncthing
	   	jetbrains.idea
		wiremix
		parsec-bin
		pkgs-master.gh
		pkgs-master.lazygit
		pkgs-master.nodejs_24
		python3
		vscode
		antigravity
		zed-editor
		thunar
		codebase-memory-mcp
		uv		
		firefox
		dbeaver-bin
                qbittorrent
                unrar
                google-chrome
                sqlite
                pkgs-master.cloudflared
                wev
		localsend
                dosbox-x
                vlc
                tor-browser
		protonup-qt
		obsidian
		scrcpy
		httptoolkit
        	pi-coding-agent
		ngrok
		grim 
		slurp 
		wl-clipboard
		satty
		wf-recorder
		nixd
		gopls
		
		lazysql
		discord

		bruno

		act
		mangohud
		ffmpeg
		libnotify
		#davinci-resolve
		(pkgs.writeShellScriptBin "toggle-record" (builtins.readFile ./scripts/toggle-record))
		(pkgs.writeShellScriptBin "capture-annotate" (builtins.readFile ./scripts/capture-annotate))
		satty
	];

	  	xdg.configFile = {
		"niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/jhon/dotfiles/niri.kdl";
	};

	programs.ssh = {
    		enable = true;
    		enableDefaultConfig = false;

    		matchBlocks = {
      			"github.com" = {
        		hostname = "github.com";
        		user = "git";
        		identityFile = "~/.ssh/id_ed25519";
        		identitiesOnly = true;
      		};
      			"github.com.w" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_work";
        identitiesOnly = true;
      };
    };
  };
  dconf.enable = false;
  #    	dconf.settings = {
  #  		"org/gnome/desktop/interface" = {
  #    			color-scheme = "prefer-dark";
  #  		};
  # };
 	programs.java = {
        	enable = true;
        	package = pkgs.openjdk21;
	};

  	home.sessionPath = [
		"/home/jhon/.bun/bin"
		"/home/jhon/.local/bin"
  	];
	home.sessionVariables = {
		GTK_USE_PORTAL = "1";
	};
	gtk = {
  		enable = true;
 		theme = {
    			name = "Adwaita-dark";
    			package = pkgs.gnome-themes-extra;
        	};
  		gtk3.extraConfig = {
   	 		gtk-application-prefer-dark-theme = 1;
  	 	};
	};

  	programs.bash = {
		enable = true;
		shellAliases = {
			update  = "sudo nixos-rebuild switch --flake /home/jhon/dotfiles#pc";
			update-lp = "sudo nixos-rebuild switch --flake /home/jhon/dotfiles#laptop";
			garbage = "sudo nix-collect-garbage -d";
			zed = "zeditor";
		};
		initExtra = ''
    		export PATH="/home/jhon/.bun/bin:$PATH"
   		'';
	};
	programs.git = {
    		enable = true;
    		settings = {
			init.defaultBranch = "main";
			user.name = "jh0nz";
			user.email = "jhondeycraft776@gmail.com";
			pull.rebase = false;
    		};
	};

	#services.syncthing = {
	#	enable = true;
	#};
	home.pointerCursor = {
		gtk.enable = true;
		package = pkgs.bibata-cursors;
		name = "Bibata-Modern-Classic";
		size = 24;

	};

	home.stateVersion = "25.11";
}
