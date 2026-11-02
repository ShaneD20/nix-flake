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
        home-manager
        gnumake
        alejandra
        disko
        pkg-config

        #--c-----#
        gcc gdb cmake valgrind

        #--rust--#
        rustc cargo rust-analyzer clippy rustfmt
      ];
    };
}