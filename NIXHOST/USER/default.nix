#{stateVersion}: 
{ pkgs, config, lib, ...}: 
{
  programs.git.config.user = {
    name = "Shane";
    email = "sunset510@gmail.com";
  };

  users.users = {
    Shane = {
      isNormalUser = true;
      description = "Shane";
      extraGroups = [
        "networkmanager"
        "wheel"
        (lib.mkIf (config.virtualisation.libvirtd.enable) "libvirtd")
        (lib.mkIf (config.virtualisation.virtualbox.host.enable) "vboxusers")
        (lib.mkIf (config.virtualisation.docker.enable) "docker")
      ];
    };
  };
  #programs.dconf.enable = true;
  #programs.dconf.settings = lib.mkIf (config.virtualisation.libvirtd.enable) {
  #  "org/virt-manager/virt-manager/connections" = {
  #    autoconnect = ["qemu:///system"];
  #    uris = ["qemu:///system"];
  #  };
  #};
}