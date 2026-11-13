{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "plasma-wallpaper-flying-snowflakes";
  version = "1.0";
  src = ./.;
  dontBuild = true;
  dontWrapQtApps = true;
  installPhase = ''
    runHook preInstall
    dir=$out/share/plasma/wallpapers/org.nixos.flyingsnowflakes
    mkdir -p $dir
    cp -r metadata.json contents $dir/
    runHook postInstall
  '';
}
