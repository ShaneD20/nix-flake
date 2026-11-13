{
#======================================== NIX (PACKAGE MANAGEMENT)
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

  boot.loader = {
    systemd-boot.configurationLimit = 5;  # only hold 5 generations
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

#======================================== SECURITY
    security = {
        rtkit.enable = true;
        polkit.enable = true;
    };
    # TODO review security

  hardware = {
    graphics.enable = true;      # OpenGL support
    graphics.enable32Bit = true; 
    enableRedistributableFirmware = true;
    bluetooth.enable = false;  
  };

#======================================== SERVICES
  services = {  
    blueman.enable = false;
    pulseaudio.enable = false; # disable for pipewire (lower latency).
    
    flatpak.enable = true;
    openssh.enable = true;
    printing.enable = true;
    #udisks2.enable = true;
    fwupd.enable = true;

    pipewire = { 
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false; # If you want to use JACK applications
    };

    desktopManager.plasma6.enable = true;    
    
  };

#======================================== screensharing
  xdg.portal = { enable = true; };
}