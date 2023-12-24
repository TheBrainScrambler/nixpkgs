{ pname
, version
, src
, extraNativeBuildInputs ? [ ]
, extraBuildInputs ? [ ]

, lib
, stdenv
, fetchFromGitHub
, makeWrapper
, cmake
, imagemagick
, bison
, flex
, nasm
, SDL2
, zlib
, libogg
, libvorbis
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  patches = [
    ./tfe-fix-cmake-libdir-override.patch
    ./tse-fix-cmake-libdir-override.patch
    ./tfe-force-using-system-path.patch
    ./tse-force-using-system-path.patch
  ];

  postPatch = ''
    substituteInPlace SamTFE/Sources/CMakeLists.txt --replace "-march=native" "-mtune=generic"
    substituteInPlace SamTSE/Sources/CMakeLists.txt --replace "-march=native" "-mtune=generic"
  '';

  nativeBuildInputs = [
    makeWrapper
    cmake
    imagemagick
    bison
    flex
    nasm
  ] ++ extraNativeBuildInputs;

  buildInputs = [
    SDL2
    zlib
    libogg
    libvorbis
  ] ++ extraBuildInputs;

  # I've tried to use patchelf --add-needed and --add-rpath with libvorbis, didn't work
  postInstall = ''
    wrapProgram $out/bin/serioussam --suffix LD_LIBRARY_PATH : ${libvorbis}/lib
    wrapProgram $out/bin/serioussamse --suffix LD_LIBRARY_PATH : ${libvorbis}/lib
  '';

  meta = with lib; {
    homepage = "https://github.com/tx00100xt/${finalAttrs.src.repo}";
    description = "Open source game engine version developed by Croteam for Serious Sam Classic";
    longDescription = ''
      Note: This package allows to run both Serious Sam: The First Encounter (serioussam)
      and The Second Encounter (serioussamse).

      For serioussam you must copy all the assets of the original games into
      ~/.local/share/Serious-Engine/serioussam for serioussam and
      ~/.local/share/Serious-Engine/serioussamse for serioussamse.
      Look at
      https://github.com/tx00100xt/${finalAttrs.src.repo}/wiki/How-to-building-a-package-for-Debian-or-Ubuntu.md#game-resources
      for instructions on how to do that.
      For both games you must also copy the files SE1_10b.gro and ModEXT.txt into the assets.
      For serioussam:
      - https://raw.githubusercontent.com/tx00100xt/${finalAttrs.src.repo}/${finalAttrs.src.rev}/SamTFE/ModEXT.txt
      - https://raw.githubusercontent.com/tx00100xt/${finalAttrs.src.repo}/${finalAttrs.src.rev}/SamTFE/SE1_10b.gro
      For serioussamse:
      - https://raw.githubusercontent.com/tx00100xt/${finalAttrs.src.repo}/${finalAttrs.src.rev}/SamTSE/ModEXT.txt
      - https://raw.githubusercontent.com/tx00100xt/${finalAttrs.src.repo}/${finalAttrs.src.rev}/SamTSE/SE1_10b.gro
    '';
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ TheBrainScrambler ];
  };
})
