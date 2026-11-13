{
   description = "Shanes's NixOS configuration";

   inputs = {
      nixos-hardware.url = "github:NixOS/nixos-hardware";
      nixpkgs-unstable.url = "github:NixOS/nixpkgs";
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
      disko.url = "github:nix-community/disko";
      disko.inputs.nixpkgs.follows = "nixpkgs";
   };

   outputs = inputs @ { self, nixpkgs, disko, ... }: 
   let
      inherit
      (builtins)
      listToAttrs
      map
      readDir
      attrNames
   ; 
   in {
      devShells.x86_64-linux = import ./devShell.nix {
         system = "x86_64-linux";
         specialArgs = inputs;
      };

      nixosConfigurations = listToAttrs (map (name: {
      inherit name;
         value = import ./host/${name}/default.nix {
            specialArgs = inputs // {
               cleanVersion = builtins.head (builtins.match "([0-9]+\\.[0-9]+).*" nixpkgs.lib.version);
            };
         };
      }) (attrNames (readDir ./host)));
   };
}