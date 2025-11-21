{ lib, stdenv, pkgs }:

let
  inherit (pkgs) fetchurl appimageTools;
  
  pname = "helium";
  version = "0.6.7.1";
  
  # Definition map of assets by architecture
  assetMap = {
    "x86_64-linux" = {
      assetName = "helium-${version}-x86_64.AppImage";
      hash = "sha256-1fqlwg0m21f0ngqdx1a4mdk8q1xp6yghqnfcc4g934w32qvc353x"; # CORRIGIDO
    };
    "aarch64-linux" = {
      assetName = "helium-${version}-arm64.AppImage";
      hash = "sha256-1wqfk42lrvqnmgfkpvdv9ma8frzp0jzihnw7mgcy2iy3ma80m8km"; # CORRIGIDO
    };
  };
  
  # Selects the asset information based on the current system (stdenv.system)
  selectedAsset = 
    if lib.hasAttr stdenv.system assetMap then
      lib.getAttr stdenv.system assetMap
    else
      # Throws an error if the architecture is not x86_64-linux or aarch64-linux
      builtins.throw "The architecture ${stdenv.system} is not supported by Helium Browser (AppImage).";

  appimageName = selectedAsset.assetName;
  appimageHash = selectedAsset.hash;

  # Download source
  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${appimageName}";
    hash = appimageHash; 
  };

  contents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;

  nameForWrapper = pname;

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/lib/helium"
    cp -r ${contents}/opt/helium/locales "$out/share/lib/helium"
    cp -r ${contents}/usr/share/* "$out/share"
    cp "${contents}/${pname}.desktop" "$out/share/applications/" || \
    cp "${contents}/usr/share/applications/${pname}.desktop" "$out/share/applications/"
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  # Add common dependencies for AppImages/Browsers
  extraPkgs = pkgs: with pkgs; [
    libglvnd
    alsa-lib
    libva
    libdrm
    gtk3
    nss
    nspr
    mesa
    libnotify 
    xorg.libXrandr
  ];

  meta = with lib; {
    description = "Helium Browser, Internet without interruptions";
    homepage = "https://github.com/imputnet/helium-linux";
    license = licenses.gpl3; 
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "helium";
  };
}