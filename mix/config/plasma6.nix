{
#==============================================================
   nixpkgs.config.allowUnfree = true;

   nix = {
      settings = {
      keep-outputs = false;       # derivations are more important (gc)
      keep-derivations = true;    # protects active build dependancies (gc)
      auto-optimise-store = true; # hard-link identical files (minimize store size)
         # Note: optimise.automatic would run daily, only optimise on build/switch is preferred
         # sudo nixos-rebuild switch && sudo nix-store --optimise
      experimental-features = [ "nix-command" "flakes" ];
      };
      gc.automatic = true;
      gc.persistent = true;
      gc.dates = "*-02,05,08,11-01 5:00"; # every 3 months
   };

#==============================================================
   boot.loader = {
      systemd-boot.configurationLimit = 5;  # only hold 5 generations
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
   };

#==============================================================
   security = {
      rtkit.enable = true;
      polkit.enable = true;
   };

#==============================================================
   hardware = {
      bluetooth.enable = false;  
      graphics.enable = true;      # OpenGL support
      graphics.enable32Bit = true; 
      enableRedistributableFirmware = true;
   };

#==============================================================
   programs = {
      vim.enable = true;
      tmux.enable = true;
      git.enable = true;
      git.lfs.enable = true;
      firefox.enable = true;

      chromium.enable = true; 
      chromium.extraOpts = {
         "HardwareAccelerationModeEnabled" = false; # use graphics acceleration when available
      };
      kdeconnect.enable = true;
   };

#==============================================================
   services = {  
      blueman.enable = false;
      pulseaudio.enable = false; # disable for pipewire (lower latency).
      
      flatpak.enable = true;
      openssh.enable = true;
      printing.enable = true;
      fwupd.enable = true;
      #udisks2.enable = true; # handled by KDE
      #gvfs.enable = true; # handled by KDE

      pipewire = { 
         enable = true;
         alsa.enable = true;
         alsa.support32Bit = true;
         pulse.enable = true;
         jack.enable = false; # If you want to use JACK applications
      };
      
      fstrim = { # SSD trim timer `lsblk --discard`` if (DISC-GRAN && DISC-MAX) drive can trim
         enable = true;   
         interval = "Mon *-*-* 01:00:00";
      };
      desktopManager.plasma6.enable = true;  

      displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      #theme = "";  
      };
   };

#==============================================================
   xdg.portal.enable = true; #screen sharing | flatpak
   # remainder of xdg is handled by Plasma6 +

}