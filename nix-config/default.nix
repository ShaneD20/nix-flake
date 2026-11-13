{ config, pkgs, ... }: 
{
  imports = [
    ./core.nix
    ./unstable.nix
  ];

  environment.systemPackages = with pkgs; [
    nettools dnsutils usbutils pciutils
    tree curl wget btop fastfetch    
    zip unzip ncdu
    gcc
    alejandra
    gnumake 
    zellij
    hwinfo
    libreoffice-qt-fresh
  ];

  programs = {
    vim.enable = true;
    tmux.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    chromium.enable = true; 
    firefox.enable = true;
  };

  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu-classic
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      dina-font
      corefonts
      vista-fonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans" "Ubuntu"];
        monospace = ["Noto Mono" "Ubuntu Mono"];
      };
    };
  };
}
