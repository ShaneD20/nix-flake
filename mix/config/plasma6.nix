{  
   # additional settings for Intel, Nividia, or laptop devices in general
   ##################################
   # https://nixos.wiki/wiki/Laptop #
   ##################################

   services = {  
      #udisks2.enable = true; #gvfs.enable = true;         # handled by KDE
      pulseaudio.enable = false;    # using pipewire (lower latency).
      blueman.enable = false;       # bluetooth

      pipewire = { 
         enable = true;
         alsa.enable = true;
         alsa.support32Bit = true;
         pulse.enable = true;
         jack.enable = false; # If you want to use JACK applications
      };
      flatpak.enable = true;
      openssh.enable = true;
      printing.enable = true;
      fwupd.enable = true;
      smartd.enable = true;
      fstrim = { # SSD trim timer `lsblk --discard`` if (DISC-GRAN && DISC-MAX) drive can trim
         enable = true;   
         interval = "weekly";
      };
      desktopManager.plasma6.enable = true;  
      displayManager.sddm = {
         enable = true;
         wayland.enable = true;
         wayland.compositor = "kwin";
         #theme = "";  
      };
   };
   xdg.portal.enable = true; #screen sharing | flatpak
   # remainder of xdg is handled by Plasma6 +

   environment.systemPackages = with pkgs; [
      kdePackages.breeze
      kdePackages.breeze-icons
   ];

   environment.etc."xdg/kdedefaults/kdeglobals".text = ''
      [KDE]
      LookAndFeelPackage=org.kde.breezedark.desktop

      [General]
      ColorScheme=BreezeDark
   '';

   environment.etc."xdg/plasmarc".text = ''
      [Theme]
      name=breeze-dark
   '';

   environment.etc."xdg/plasma-org.kde.plasma.desktop-appletsrc".text = ''
      [Containments][1][Wallpaper][org.kde.image][General]
      Image=file://${.wall.png}
   '';
}