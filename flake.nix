{
	description = "nixos config hyprland";
	inputs = {
		nixpkgs.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		hyprland.url = "github:hyprwm/Hyprland";
		thorium.url = "github:Rishabh5321/thorium_flake";
		nixpkgs-master.url = "github:nixos/nixpkgs/master";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
};
  	outputs = {self, nixpkgs, home-manager, hyprland,...}@inputs:{
 		pkgs-unstable = import inputs.nixpkgs-unstable {
 			system = "x86_64-linux";
 			config.allowUnfree = true;
 		};
		pkgs-master = import inputs.nixpkgs-master {
			system = "x86_64-linux";
			config.allowUnfree = true;
		};
 		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
 			system = "x86_64-linux";
 			specialArgs = { 
				inherit inputs;
				pkgs-unstable = self.pkgs-unstable;
				pkgs-master = self.pkgs-master;
			};
 			modules = [
 				./hardware-configuration.nix
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
 }
