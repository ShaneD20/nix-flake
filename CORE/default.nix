{
  config, pkgs, ...
}: {
  imports = [
    ./unstable.nix
  ];

  # nix-collect-garbage
  # nh clean all --keep 5 // nixpkgs
  nix = {
    gc = {               
      automatic = true;
      persistent = true;
      dates = "*-02,06,10-01 5:00"; # every 4 months
    };
    settings = {
      keep-outputs = true;        # protects active build dependancies (gc)
      keep-derivations = true;    # protects active build dependancies (gc)
      auto-optimise-store = true; # hard-link identical files (minimize store size)
    };
    settings.experimental-features = [
      "nix-command" "flakes"
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;  # only hold 5 generations
  boot.loader.efi.canTouchEfiVariables = true;
  
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl 
    wget 
    btop 
    nettools 
    dnsutils 
    usbutils 
    pciutils
    alejandra
    gnumake 
    ncdu
    hyfetch
    zellij
    btop
    hwinfo
    libreoffice
  ];

  programs = {
    git = {
      enable = true;
      package = pkgs.git;
    };
    firefox = {
      enable = true;
      package = pkgs.firefox;
    };
    vim = {
      enable = true;
      package = pkgs.vim;
    };
    tmux = {
      enable = true;
      package = pkgs.tmux;
    };
  };

  programs.chromium.enable = true;  #no package, chromium is unique
  #needed for Discord and Chromium
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # screensharing
  xdg.portal = {
    enable = true;
    #extraPortals = [ pkgs.xdg-desktop-portal-kde ];
    #config.common.default = "*";
  };

  # Audio
  services = {  
    pulseaudio.enable = false; # disable for pipewire (lower latency).
    pipewire = { 
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true; # If you want to use JACK applications
    };
    printing.enable = true;
  };

  networking.networkmanager.enable = true;
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
    
  security.rtkit.enable = true;
  security.polkit.enable = true; # Polkit

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu-classic
      vazir-fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
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