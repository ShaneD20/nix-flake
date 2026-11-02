{
  config, pkgs, ...
}: {
    imports = [
    ./unstable.nix
  ];

  # NixOS upgrade
  # sudo nixos-rebuild switch --upgrade

  # NixOS garbage collect Nix Store
  # nix-collect-garbage
  # nh clean all --keep 5 // nixpkgs

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
  time.timeZone = "America/Los_Angeles";
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;
  ## Utilities ##
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
    #python314
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
    chromium = {
      enable = true;  #package = pkgs.chromium; #chromium is unique?
    };
  };



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