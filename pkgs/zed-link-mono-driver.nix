{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  autoAddDriverRunpath,
  qt5,
  jetpack,
}:
stdenv.mkDerivation rec {
  pname = "zed-link-mono-driver";
  version = "1.3.1-SL-MAX9296-all-L4T36.4.0";

  src = fetchurl {
    url = "https://stereolabs.sfo2.cdn.digitaloceanspaces.com/utils/drivers/ZEDX/1.3.1/R36.4/stereolabs-zedlink-mono_${version}_arm64.deb";
    sha256 = "sha256-//TAUb0e5IVdjZIx/uc7Tzlm8EaN1LE9dWAkmpWfB74=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    autoAddDriverRunpath
    dpkg
  ];

  buildInputs = [
    qt5.full
    jetpack.l4t-camera
  ];

  camPkg = jetpack.l4t-camera;

  unpackCmd = "dpkg -x $curSrc src";
  dontConfigure = true;
  dontBuild = true;
  noDumpEnvVars = true;

  # In cross-compile scenarios, the directory containing `libgcc_s.so` and other such
  # libraries is actually under a target-specific directory such as
  # `${stdenv.cc.cc.lib}/aarch64-unknown-linux-gnu/lib/` rather than just plain `/lib` which
  # makes `autoPatchelfHook` fail at finding them libraries.
  postFixup = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    addAutoPatchelfSearchPath ${stdenv.cc.cc.lib}/*/lib/
  '';

  installPhase = ''
    runHook preInstall

    rm tmp/driver_zed_loader.service
    rm tmp/zed_x_daemon.service
    rm -r tmp/R36.4.0/
		install -m644 -D tmp/R36.4.3/libnvisppg.so usr/lib/aarch64-linux-gnu/tegra/libnvisppg.so

    rm -r boot/stereolabs
    rm boot/tegra234-p3737-camera-zedlink-duo-sl-overlay.dtbo
    rm boot/tegra234-p3737-camera-zedlink-quad-sl-overlay.dtbo
    rm boot/tegra234-p3768-camera-zedbox-duo-sl-overlay.dtbo
    rm boot/tegra234-p3768-camera-zedbox-mini-sl-overlay.dtbo
    rm boot/tegra234-p3768-camera-zedbox-mono-sl-overlay.dtbo
    rm boot/tegra234-p3768-camera-zedlink-duo-sl-overlay.dtbo

    rm -r usr/share/

    mkdir -p $out
    mv -t $out usr/ boot/
    mv $out/usr/sbin $out/bin/
    mv $out/usr/lib $out/lib/
    mv $out/lib/modules/5.15.148-tegra $out/lib/modules/5.15.148
    mkdir $out/nvcam/
    mv var/nvidia/nvcam/settings $out/nvcam/

    runHook postInstall
  '';

  meta = with lib; {
    platforms = platforms.linux;
  };
}
