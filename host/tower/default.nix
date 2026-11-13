{specialArgs, ...}:
specialArgs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;
  system = "x86_64-linux";
  
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix

    #(import "${specialArgs.home-manager}/nixos")
    #(import ../USER {stateVersion = specialArgs.cleanVersion;})
    ../USER

    specialArgs.disko.nixosModules.disko
    ./disk-config.nix

    ../../login
    ../../nix-config
    ../../mixin/virtualization.nix
    ../../mixin/steam.nix
  ];
}