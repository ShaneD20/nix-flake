#{stateVersion}: 
{ pkgs, config, lib, ...}: 
{
   environment.etc."gitconfig".text = ''
      [shane]
         name = Shane
         email = sunset510@gmail.com
      [init]
         defaultBranch = main
      [core]
         editor = vim
   '';

 # programs.dconf.enable = true;
 # programs.dconf.settings = lib.mkIf (config.virtualisation.libvirtd.enable) {
 #   "org/virt-manager/virt-manager/connections" = {
 #     autoconnect = ["qemu:///system"];
 #     uris = ["qemu:///system"];
 #   };
 # };
 
   users.users = {
      shane = {
         isNormalUser = true;
         description = "Shane";
         extraGroups = [
            "networkmanager"
            "wheel"
            (lib.mkIf (config.virtualisation.libvirtd.enable) "libvirtd")
            (lib.mkIf (config.virtualisation.virtualbox.host.enable) "vboxusers")
            (lib.mkIf (config.virtualisation.docker.enable) "docker")
         ];
         packages = with pkgs; [
            #--c-----#
            gdb cmake valgrind
            #--rust--#
            rustc cargo rust-analyzer clippy rustfmt
            claude-code 
         ];
      };
   };
}