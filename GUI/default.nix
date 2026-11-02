{
  # Enable Plasma 
  services = { # Optionally enable xserver
    # xserver = { enable = true; xkb.variant = ""; xkb.layout = "us"; }; # X11 windowing system.
    # displayManager.plasma-login-manager.enable = true; # full wayland
    
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true; # Enable experimental Wayland support for SDDM
    };
  };
}