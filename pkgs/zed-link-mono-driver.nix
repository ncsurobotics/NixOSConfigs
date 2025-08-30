{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "zed-link-mono-driver";
  version = "1.3.1-SL-MAX9296-all-L4T36.4.0";

  src = fetchurl {
    url = "https://stereolabs.sfo2.cdn.digitaloceanspaces.com/utils/drivers/ZEDX/1.3.1/R36.3/stereolabs-zedlink-mono_${version}_arm64.deb";
    sha256 = "";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  unpackCmd = "dpkg -x $curSrc src";

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D studio-link-standalone-v${version} $out/bin/studio-link
    runHook postInstall
  '';

  # installPhase = ''
  #   runHook preInstall

  #   mkdir -p $out
  #   mv opt/ usr/share/ $out

  #   # `/opt/unityhub/unityhub` is a shell wrapper that runs `/opt/unityhub/unityhub-bin`
  #   # Which we don't need and overwrite with our own custom wrapper
  #   makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/opt/unityhub/unityhub \
  #     --add-flags $out/opt/unityhub/unityhub-bin \
  #     --argv0 unityhub

  #   # Link binary
  #   mkdir -p $out/bin
  #   ln -s $out/opt/unityhub/unityhub $out/bin/unityhub

  #   # Replace absolute path in desktop file to correctly point to nix store
  #   substituteInPlace $out/share/applications/unityhub.desktop \
  #     --replace /opt/unityhub/unityhub $out/opt/unityhub/unityhub

  #   runHook postInstall
  # '';

  meta = with lib; {
    platforms = platforms.linux;
  };
}
