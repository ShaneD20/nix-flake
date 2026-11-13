{ config, pkgs, ... }: 
{
   imports = [
      ./plasma6.nix
      ./unstable.nix
   ];

   environment.systemPackages = with pkgs; [
      nettools dnsutils usbutils pciutils
      tree curl wget btop fastfetch    
      zip unzip ncdu
      gcc
      alejandra
      gnumake 
      zellij
      hwinfo
      libreoffice-qt-fresh
   ];

   systemd.services.flatpak-repo = {      # desired once per install
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"]; # avoid failing silently
      serviceConfig.Type = "oneshot";  # not a daemon
      path = [pkgs.flatpak];
      script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
   };
   # services.printing.drivers = [ pkgs.gutenprint ]; # printer might need

   fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages = with pkgs; [
         ubuntu-classic
         noto-fonts
         noto-fonts-cjk-sans
         noto-fonts-color-emoji
         liberation_ttf
         dina-font
         corefonts
         vista-fonts
      ];

      fontconfig = {
         defaultFonts = {
            serif = ["Noto Serif"];
            sansSerif = ["Noto Sans" "Ubuntu"];
            monospace = ["Noto Mono" "Ubuntu Mono"];
         };
      };
   };
}
