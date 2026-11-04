{ lib, config, pkgs, ... }:
{
  networking.hostName = "tower";
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [lact nvtopPackages.amd];
  systemd.packages = with pkgs; [lact nvtopPackages.amd];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # Onboard Intel Wireless-AC 3168 (wlp4s0) stays off; only the MediaTek
  # MT7922 card (wlp8s0, mt7921e) should be used for wifi. netdevs.enable
  # only applies to virtual netdevs and was a no-op for this physical card.
  boot.blacklistedKernelModules = ["iwlwifi"];
  system.stateVersion = "26.05";
}