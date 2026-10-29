{specialArgs, ...}:
specialArgs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix

    (import "${specialArgs.home-manager}/nixos")
    (import ../../users/shane {stateVersion = specialArgs.cleanVersion;})

    specialArgs.disko.nixosModules.disko
    ./disk-config.nix
    ./amd.nix

    ../USER
    ../../CORE

    ../../GUI/plasma.nix

    ../../MIXIN/steam
    ../../MIXIN/libreoffice
    ../../MIXIN/docker
    ../../MIXIN/virtualization
    ../../MIXIN/claude
  ];
}