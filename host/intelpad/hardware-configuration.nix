{ config, lib, pkgs, modulesPath, ... }: 
{
   imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
   ];
   services.thermald.enable = true; #intel CPUs

   nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
   boot.kernelModules = ["kvm-intel"];
   boot.kernelPackages = pkgs.linuxPackages_latest;
   boot.extraModulePackages = [];
   boot.initrd.kernelModules = [];
   boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];

   hardware.nvidia.modesetting.enable = true;

   hardware = {
      cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      graphics.extraPackages = with pkgs; [
         intel-media-driver
      ];
   };
}
