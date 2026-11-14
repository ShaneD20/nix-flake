{ pkgs, ... }:
{
   services.displayManager.sddm.theme = "flying-nixflakes";
   environment.systemPackages = [
      (pkgs.callPackage ./org.sddm.nixflakes {})
      (pkgs.callPackage ./org.wall.nixflakes {})
   ];
}