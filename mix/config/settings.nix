{ config, ... }: 
{
   #==============================================================
   nixpkgs.config.allowUnfree = true;

   nix = {
      # Disk Cleanup
      gc.automatic = true;
      gc.persistent = true;
      gc.dates = "*-02,05,08,11-01 5:00"; # every 3 months
      
      settings = {
         experimental-features = [ "nix-command" "flakes" ];
         
         # Disk usage
         keep-outputs = false;       # can accrue diskspace | turning on may be a benefit for devshell or devenv
         keep-derivations = true;    # very small recipes, holding prevents gc from being too aggresive
         auto-optimise-store = true; # hard-link identical files (minimize store size)
         # sudo nixos-rebuild switch && sudo nix-store --optimise (1st install)
         
         # RAM usage
         max-jobs = 3;  # how many packages build in parallel
         cores = 3;     # how many threads each build may use
      };

      daemonCPUSchedPolicy = "batch";
   };

#==============================================================
   # Boot Memory Management
   boot.loader = {
      systemd-boot.configurationLimit = 5;  # only hold 5 generations
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
   };
   systemd.services = {
      prune-system-generations = {
      description = "Keeps 5 most recent generations and prune the remaining for gc.";
      wantedBy = [ "nix-gc.service" ];
      before = [ "nix-gc.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
         ${config.nix.package}/bin/nix-env --profile /nix/var/nix/profiles/system \
         --delete-generations +5
      '';
      };
   };

#==============================================================
   security = {
      rtkit.enable = true;
      polkit.enable = true;
   };

#==============================================================
   hardware = {
      bluetooth.enable = false;  
      graphics.enable = true;      # OpenGL (mesa, libGL.s, libEGL.so, libgbm, libdrm, libGL)
      graphics.enable32Bit = true; 
      enableRedistributableFirmware = true;
   };
}