{
  # Enable Plasma (Wayland)
  services = {
    desktopManager.plasma6.enable = true;
    
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
    };
  };
}