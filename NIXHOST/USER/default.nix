{stateVersion}: {
  pkgs,
  config,
  lib,
  ...
}: {

  users.users.shane = {
    isNormalUser = true;
    description = "Shane";
    extraGroups = [
      "networkmanager"
      "wheel"

      (lib.mkIf (config.virtualisation.libvirtd.enable) "libvirtd")
      (lib.mkIf (config.virtualisation.virtualbox.host.enable) "vboxusers")
      (lib.mkIf (config.virtualisation.docker.enable) "docker")
      (lib.mkIf (config.services.sunshine.enable) "input")
    ];
  };
  
  home-manager.users.shane.home.stateVersion = stateVersion;

  home-manager.users.shane.dconf.settings = lib.mkIf (config.virtualisation.libvirtd.enable) {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home-manager.users.shane.programs.git = {
    enable = true;
    settings.user.name = "Shane";
    settings.user.email = "shaynepalmer.d20@gmail.com";
    settings.core.editor = "nano";
    settings.init.defaultBranch = "main";
    lfs.enable = true;
  };
  
}