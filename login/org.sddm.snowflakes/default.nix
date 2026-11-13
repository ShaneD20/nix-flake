{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "flying-snowflakes";
  version = "1.0";
  src = ./.;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    dir=$out/share/sddm/themes/flying-snowflakes
    mkdir -p $dir
    cp -r *.qml metadata.desktop theme.conf assets $dir/
    runHook postInstall
  '';
}
