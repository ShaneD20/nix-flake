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
 
   users.users = {
      shane = {
         isNormalUser = true;
         description = "Shane";
         extraGroups = [
            "networkmanager"
            "wheel"
            "kvm"
            (lib.mkIf (config.virtualisation.libvirtd.enable) "libvirtd")
            (lib.mkIf (config.virtualisation.virtualbox.host.enable) "vboxusers")
            (lib.mkIf (config.virtualisation.docker.enable) "docker")
         ];
         packages = with pkgs; [
            #--Non-Linux--#
            zip unzip 
            #--c-----#
            gcc gdb cmake valgrind
            #--rust--#
            rustc cargo rust-analyzer clippy rustfmt
            claude-code 
         ];
      };
   };
}