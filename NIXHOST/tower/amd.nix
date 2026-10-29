
{ config, lib, pkgs, ... }: {

  hardware = {
    ### Enable OpenGL ###
    graphics = {
      enable = true;
      enable32bit = true;
    };
    amdgpu.opencl.enable = true;
  };

  # Workaround for amdgpu "ring gfx timeout" / GPU resets hanging the whole
  # session during DX12-via-vkd3d games (observed with Nightreign on this
  # RX 580 / Polaris10 card).
  boot.kernelParams = ["amdgpu.cwsr_enable=0"];

  environment.systemPackages = with pkgs; [lact nvtopPackages.amd];
  systemd.packages = with pkgs; [lact nvtopPackages.amd];
  systemd.services.lactd.wantedBy = ["multi-user.target"];
}