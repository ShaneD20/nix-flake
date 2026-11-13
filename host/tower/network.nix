{ config, pkgs, ... }:
{
   system.stateVersion = "26.05"; # 1st install version
   networking = {
      networkmanager.enable = true;
      firewall.enable = true;
      hostName = "tower";
   };

   time.timeZone = "America/Los_Angeles";

   # Select internationalisation propserties.
   i18n.defaultLocale = "en_US.UTF-8";
   i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
   };

   environment.systemPackages = with pkgs; [lact nvtopPackages.amd];
   systemd.packages = with pkgs; [lact nvtopPackages.amd];
   systemd.services.lactd.wantedBy = ["multi-user.target"];

   # Onboard Intel Wireless-AC 3168 (wlp4s0) stays off; only the MediaTek
   # MT7922 card (wlp8s0, mt7921e) should be used for wifi. netdevs.enable
   # only applies to virtual netdevs and was a no-op for this physical card.
   boot.blacklistedKernelModules = ["iwlwifi"];
}