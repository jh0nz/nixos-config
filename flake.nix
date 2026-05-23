{
	description = "nixos config hyprland";
	inputs = {
		nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixpkgs-master.url = "github:nixos/nixpkgs/master";
		# shapez-ce = {
		#                       url = "path:/home/jhon/repos/shapez-ce";
		#                       inputs.nixpkgs.follows = "nixpkgs";
		#               };
		#
};
  	outputs = {self, nixpkgs, home-manager, ...}@inputs: {
		pkgs-master = import inputs.nixpkgs-master {
			system = "x86_64-linux";
			config.allowUnfree = true;
		};
		nixosConfigurations = {	
			pc = nixpkgs.lib.nixosSystem {
 				system = "x86_64-linux";
 				specialArgs = { 
					inherit inputs;
					pkgs-master = self.pkgs-master;
				};
 				modules = [
 					./hosts/pc/hardware-configuration.nix
 					./configuration.nix
 					home-manager.nixosModules.home-manager {
 						home-manager.useGlobalPkgs = true;
 						home-manager.useUserPackages = true;
 						home-manager.users.jhon = import ./home.nix;
 						home-manager.extraSpecialArgs = { 
 							inherit inputs; 
 							pkgs-unstable = self.pkgs-unstable;
							pkgs-master = self.pkgs-master;
 						};
 					}
				];
 			};
	  		laptop = nixpkgs.lib.nixosSystem {
 				system = "x86_64-linux";
 				specialArgs = { 
					inherit inputs;
					pkgs-master = self.pkgs-master;
				};
 				modules = [
 					./hosts/laptop/hardware-configuration.nix
 					./configuration.nix
 					home-manager.nixosModules.home-manager {
 						home-manager.useGlobalPkgs = true;
 						home-manager.useUserPackages = true;
 						home-manager.users.jhon = import ./home.nix;
 						home-manager.extraSpecialArgs = { 
 							inherit inputs; 
 							pkgs-unstable = self.pkgs-unstable;
							pkgs-master = self.pkgs-master;
 						};
 					}
				];
 			};
		};
 	};
 }
