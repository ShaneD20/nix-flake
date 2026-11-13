{ config, pkgs, ... } :
{
   programs.firefox = {
      package = pkgs.firefox;
      policies = {
         DisableTelemetry = true;
         DisablePocket = true;
         DisableFirefoxStudies = true;
         DontCheckDefaultBrowser = true;
      };
      preferences = {
         "privacy.globalprivacycontrol.enabled" = true;
      };
   };
}