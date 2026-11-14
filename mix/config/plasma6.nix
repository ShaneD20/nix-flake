{  
   # additional settings for Intel, Nividia, or laptop devices in general
   ##################################
   # https://nixos.wiki/wiki/Laptop #
   ##################################

   services = {  
      pulseaudio.enable = false;    # using pipewire (lower latency).
      blueman.enable = false;       # bluetooth
      #udisks2.enable = true;       # handled by KDE
      #gvfs.enable = true;          # handled by KDE

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
         interval = "Mon *-*-* 01:00:00";
      };
      desktopManager.plasma6.enable = true;  
      displayManager.sddm = {
         enable = true;
         wayland.enable = true;
         wayland.compositor = "kwin";
         #theme = "";  
      };
   };
   programs.kdeconnect.enable = true;
   xdg.portal.enable = true; #screen sharing | flatpak
   # remainder of xdg is handled by Plasma6 +
}