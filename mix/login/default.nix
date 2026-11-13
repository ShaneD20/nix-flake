{ pkgs, ... }:
{
   services.displayManager.sddm.theme = "flying-snowflakes";
   environment.systemPackages = [
      (pkgs.callPackage ./org.sddm.nixflakes {})
      (pkgs.callPackage ./org.wall.nixflakes {})
   ];
}