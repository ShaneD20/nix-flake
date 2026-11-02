{
  config,
  pkgs,
  lib,
  ...
}: {

  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    # gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin];
    # VKD3D_FEATURE_LEVEL=12_0 %commands% # critical for Fromsoft (12 mirrors Direct x)
    # RADV_DEBUG=nofastclears,nohiz # AMD 580 relevants
  };

  environment.systemPackages = [ pkgs.steam-run ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];
    
  boot.kernelPackages = pkgs.linuxPackages_latest;
}