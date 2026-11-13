{ config, pkgs, nixpkgs-unstable, ... }: 
let
   unstable-pkgs = import nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfree = true;
   };
in 
{
   environment.systemPackages = with unstable-pkgs; [
      vscode
   ];
}