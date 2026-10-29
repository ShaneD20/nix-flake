{
  # Enable Plasma 
  services = { # Optionally enable xserver
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };
}