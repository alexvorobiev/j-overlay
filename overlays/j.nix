{ lib
, stdenv
, fetchFromGitHub
, which
, gmp
, avx2Support ? stdenv.hostPlatform.avx2Support
, nasm
, makeWrapper
, pcre2
, libxml2
, libz
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "j";
  version = "9.7.0-dev";

  src = fetchFromGitHub {
    owner = "jsoftware";
    repo = "jsource";
    rev = "dae474f99e060d981bd34148b117307506557654";
    hash = "sha256-Gnd0Nqmxr/BQnOkWiygE9w6ojT1GO0Cus16SJK+AG5c=";
  };

  nativeBuildInputs = [  makeWrapper ];
  buildInputs = [ nasm gmp pcre2 libxml2 libz sqlite which ];

  patches = [
    ./fix-install-path.patch
  ];

  postPatch = ''
    substituteInPlace jlibrary/system/main/stdlib.ijs \
      --replace-fail "/sbin/ldconfig -p" echo
  '';

  enableParallelBuilding = true;

  dontConfigure = true;

  # Emulate jplatform64.sh configuration variables
  jplatform =
    if stdenv.hostPlatform.isDarwin then "darwin"
    else if stdenv.hostPlatform.isAarch then "raspberry"
    else if stdenv.hostPlatform.isLinux then "linux"
    else "unsupported";

  j64x =
    if stdenv.hostPlatform.is32bit then "j32"
    else if stdenv.hostPlatform.isx86_64 then
      if stdenv.hostPlatform.isLinux && avx2Support then "j64avx2" else "j64"
    else if stdenv.hostPlatform.isAarch64 then
      if stdenv.hostPlatform.isDarwin then "j64arm" else "j64"
    else "unsupported";

  env.NIX_LDFLAGS = "-lgmp";
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=stringop-overflow"
  ];

  buildPhase = ''
    runHook preBuild
    MAKEFLAGS+=" ''${enableParallelBuilding:+-j$NIX_BUILD_CORES}" \
      jplatform=${jplatform} j64x=${j64x} make2/build_all.sh
    cp -v bin/${jplatform}/${j64x}/* jlibrary/bin/
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/j
    cp -r jlibrary/{addons,system} $out/share/j/
    cp -r jlibrary/bin $out/
    runHook postInstall
  '';

  doInstallCheck = false; # The "gregex" test fails due to not finding PCRE2

  installCheckPhase = ''
    runHook preInstallCheck
    HOME="$TMPDIR" $out/bin/jconsole -lib $out/bin/libj* script/testga.ijs
    runHook postInstallCheck
  '';

  postFixup =
    let
      libraryPath = lib.makeLibraryPath [
        pcre2
        libxml2
        libz
        sqlite
      ];
    in ''
      wrapProgram "$out/bin/jconsole"     \
        --prefix LD_LIBRARY_PATH : ${libraryPath}
    '';

  meta = with lib; {
    homepage = "https://jsoftware.com/";
    changelog = "https://code.jsoftware.com/wiki/System/ReleaseNotes";
    description = "J programming language, an ASCII-based APL successor";
    longDescription = ''
      J is a high-level, general-purpose programming language that is
      particularly suited to the mathematical, statistical, and logical analysis
      of data. It is a powerful tool for developing algorithms and exploring
      problems that are not already well understood.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raskin synthetica ];
    broken = stdenv.hostPlatform.isDarwin;
    platforms = platforms.all;
    mainProgram = "jconsole";
  };
}
