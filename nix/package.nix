# MathUtils Studio para Nix y NixOS.
#
# Empaqueta el .tar.gz de Linux de cada release (la aplicación ya lleva su propio runtime de Java) y le arregla los
# enlaces con autoPatchelfHook. La versión y el hash de las dos líneas de abajo los actualiza el flujo de GitHub
# Actions (.github/workflows/package.yml) cada vez que se publica una release.
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  copyDesktopItems,
  makeDesktopItem,
  alsa-lib,
  atk,
  cairo,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  libGL,
  pango,
  xorg,
  zlib,
}:

let
  version = "0.8.2";
  hash = "sha256-X0rc8qnWxddKQSq5JVB5Ete02tCox8z4idA3NwNeFa0=";
in
stdenv.mkDerivation {
  pname = "mathutils-studio";
  inherit version;

  src = fetchurl {
    url = "https://github.com/blacknoize404/MathUtils-Studio/releases/download/v${version}/MathUtilsStudio-${version}-linux-x86_64.tar.gz";
    inherit hash;
  };

  # El .tar.gz trae una carpeta MathUtilsStudio con bin, lib (app y runtime), el icono y un install.sh
  sourceRoot = "MathUtilsStudio";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  # Las bibliotecas que piden el lanzador, el JDK y JavaFX (se sacaron con sus DT_NEEDED)
  buildInputs = [
    alsa-lib
    atk
    cairo
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gtk3
    libGL
    pango
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
    zlib
  ];

  # El envoltorio lo hacemos nosotros (con los datos de GTK dentro)
  dontWrapGApps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin
    cp -r . $out/opt/mathutils-studio
    rm -f $out/opt/mathutils-studio/install.sh $out/opt/mathutils-studio/mathutils-studio.desktop

    install -Dm444 mathutils-studio.svg $out/share/icons/hicolor/scalable/apps/mathutils-studio.svg
    install -Dm444 lib/MathUtilsStudio.png $out/share/pixmaps/mathutils-studio.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/mathutils-studio/bin/MathUtilsStudio $out/bin/mathutils-studio \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "mathutils-studio";
      desktopName = "MathUtils Studio";
      genericName = "Calculadora matemática paso a paso";
      comment = "Derivadas, límites, integrales, matrices, estadística y más, explicados paso a paso";
      exec = "mathutils-studio";
      icon = "mathutils-studio";
      categories = [
        "Education"
        "Science"
        "Math"
      ];
    })
  ];

  meta = {
    description = "Calculadora y solucionadores matemáticos paso a paso";
    homepage = "https://github.com/blacknoize404/MathUtils-Studio";
    license = lib.licenses.unfree;
    mainProgram = "mathutils-studio";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
