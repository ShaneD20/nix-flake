{
  system,
  specialArgs,
  ...
}: {
  default = let
    pkgs = import specialArgs.nixpkgs {
      system = "${system}";
    };
    disko = specialArgs.disko.packages.${system}.default;
  in
    pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        nix
        nixos-rebuild
        nixVersions.latest
        vim
        gnumake
        alejandra
        disko
        pkg-config
        # home-manager
      ];
    };
}