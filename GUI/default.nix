{ pkgs, self, ... }:
{
  # Wayland
  services = {
    desktopManager.plasma6.enable = true;    
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      theme = "flying-snowflakes";
    };
  };
  environment.systemPackages = [
    (pkgs.callPackage ./flying-snowflakes {})
    (pkgs.callPackage ./org.wall.snowflakes {})
  ];
}