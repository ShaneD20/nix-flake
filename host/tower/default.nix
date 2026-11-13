{specialArgs, ...}: specialArgs.nixpkgs.lib.nixosSystem 
{
   inherit specialArgs;

   system = "x86_64-linux";

   modules = [
      ./hardware-configuration.nix
      ./network.nix

      specialArgs.disko.nixosModules.disko
      ./disk-config.nix

      ../../mix/user
      ../../mix/login
      ../../mix/config
      ../../mix/boxes
      ../../mix/steam
      ../../mix/firefox
   ];
}