{
  # Enable Plasma (Wayland)
  services = {
    desktopManager.plasma6.enable = true;
    
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
    };

    # Audio
    pulseaudio.enable = false; # disable for pipewire (lower latency).
    pipewire = { 
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true; # If you want to use JACK applications, uncomment this
    };
    printing.enable = true;
  };
}