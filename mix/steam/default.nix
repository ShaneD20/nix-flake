{ config, pkgs, lib, ... }: 
{
   hardware.steam-hardware.enable = true;
   hardware.amdgpu.overdrive.enable = true;
   services.lact.enable = true;

   programs = {
      steam = {
         enable = true;
         extraCompatPackages = [ pkgs.proton-ge-bin];
         # gamescopeSession.enable = true;
         # VKD3D_FEATURE_LEVEL=12_0 %commands% # critical for DirectX only games: MH Wilds, Fromsoft
      };
      gamemode.enable = true;
   };

   environment.systemPackages = [ pkgs.steam-run ];

   nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
         "steam"
         "steam-original"
         "steam-run"
      ];
}