
{ config, lib, pkgs, ... }: {

  hardware = {
    graphics = {
      enable = true;      # OpenGL support
      enable32Bit = true; # 32 Bit Steam games
    };
    amdgpu.opencl.enable = true;
  };
  environment.systemPackages = with pkgs; [lact nvtopPackages.amd];
  systemd.packages = with pkgs; [lact nvtopPackages.amd];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # RX 580 Specific
  programs.gamemode.enable = true;  # 580 needs the help
  #boot.kernelParams = ["amdgpu.cwsr_enable=0"]; # 0 disables compute wave save/restore
}