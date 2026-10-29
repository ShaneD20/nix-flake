{
  config,
  pkgs,
  lib,
  options,
  ...
}: {
  # Enable Xorg/Xserver as base infrastructure (required for Cinnamon package setup)
  services.xserver.enable = true;

  # Enable experimental Wayland support
  programs.wayland.enable = true;

  services.xserver.desktopManager.cinnamon.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  environment.systemPackages = [
    pkgs.gnome-software
  ];
  environment.cinnamon.excludePackages = [
    pkgs.blueman
  ];
}