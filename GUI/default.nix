{ pkgs, self, ... }:
{
  # Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
    theme = "flying-snowflakes";  
  };
  environment.systemPackages = [
    (pkgs.callPackage ./org.sddm.snowflakes {})
    (pkgs.callPackage ./org.wall.snowflakes {})
  ];
}