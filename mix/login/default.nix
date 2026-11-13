{ pkgs, ... }:
{
   services.displayManager.sddm.theme = "flying-snowflakes";
   environment.systemPackages = [
      (pkgs.callPackage ./org.sddm.snowflakes {})
      (pkgs.callPackage ./org.wall.snowflakes {})
   ];
}