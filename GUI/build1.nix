
# flake.nix
{
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };
}

# configuration.nix
{
  config,
  pkgs,
  lib,
  options,
  ...
}: {
  imports = [
    # ./hardware-configuration.nix
  ];
  
  #---------------------------------------#

  services = { 
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      withUWSM = true; # recommended for most users - Nix Wiki
    };
    # desktopManager.enable ???
  };

  #---------------------------------------#

  programs = {
    
    hyprland = { # Wayland + Hyprland
      enable = true;
      xwayland.enable = true;
    };

    waybar = {
      enable = true;
      systemd.enable = true; # Automatically handle restarts with systemd
      settings.mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        output = [
          "eDP-1" "HDMI-A-1"
        ];
        modules-left = [ "hyprland/workspaces" "hyprland/mode" "hyprland/taskbar" ];
        modules-right = [ "clock" "cpu" "batter" "memory" ];
      };
      stye = ''
        * { 
        }
      ''
    };

    # User Programs
    zsh.enable = true;
    firefox.enable = true;
  };
  
  #---------------------------------------#
  wayland.windowManager.hyperland = {
    enable = true;

    decoration = {
      shadow_offset = "0 5";
    };
    "$mod" = "SUPER";

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod, ALT, mouse: 272, resizewindow"
    ];
    settings = {
      #sync hyperland colors with rest of system?
      #general = with config.colorScheme.colors; {
      #  "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
      #  "col.inactive_border" = "rgba(${base00}ff)";
      #}
    };
  };
  #---------------------------------------#

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  #---------------------------------------#

  environment.systemPackages = with pkgs; [
    # Hyprland desktop
    waybar
    rofi-wayland
    wl-clipboard
    dunst

    # Terminal
    zsh

    # KDE Applications
    dolphin # files
    ark     # compression
    okular  # doc viewer

    # Useful KDE helpers
    kdePackages.kwallet
    kdePackages.kwallet-pam

    # Screenshot tools
    slurp

    # extras
    papirus-icon-theme
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    # Kvantum 
    #   Lightly theme
    # Papirus icons
    #   set
    # Waybar
    #   rounded with glass blur
    # Hyprland 
    #   blur enabled
    # Dolphin themed 
    #   with a blue-green Aero palette
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
  ];
}