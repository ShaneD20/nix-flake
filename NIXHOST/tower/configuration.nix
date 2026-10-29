{ lib, config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tower";
  services.fwupd.enable = true;

  # Onboard Intel Wireless-AC 3168 (wlp4s0) stays off; only the MediaTek
  # MT7922 card (wlp8s0, mt7921e) should be used for wifi. netdevs.enable
  # only applies to virtual netdevs and was a no-op for this physical card.
  boot.blacklistedKernelModules = ["iwlwifi"];
  system.stateVersion = "26.05";
}