{
  config, pkgs, ...
}: {
    imports = [
    ./unstable.nix
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  ## Utilities ##
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    ncdu
    htop
    tmux
    nettools
    gnumake
    hyfetch
    usbutils
    pciutils
    dnsutils
    hwinfo
    alejandra # Nix Code Formatting
    pavucontrol # Audio control
    brightnessctl # Brightness
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = "America/Los_Angeles";
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

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

  services = {
    xserver = { # X11 windowing system.
      enable = true; 
      xkb.variant = "";
      xkb.layout = "us";
    };

    pulseaudio.enable = false; # Enable sound with pipewire.
    pipewire = { # Audio
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    printing.enable = true;
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