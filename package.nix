{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,
  source,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "orion-browser";
  inherit (source) version;

  src = fetchurl {
    inherit (source) url hash;
  };

  strictDeps = true;
  __structuredAttrs = true;

  unpackCmd = "unzip -q $curSrc -x '__MACOSX/*' '*:com.apple.*'";

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R Orion.app "$out/Applications"
    makeWrapper "$out/Applications/Orion.app/Contents/MacOS/Orion" "$out/bin/orion"

    runHook postInstall
  '';

  passthru.updateScript = ./scripts/update.sh;

  meta = {
    description = "WebKit-based web browser by Kagi";
    homepage = "https://orionbrowser.com/";
    changelog = "https://orionbrowser.com/updates/orion-release-notes";
    license = lib.licenses.unfree;
    mainProgram = "orion";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
