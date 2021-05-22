{ lib, stdenv, fetchurl, system ? stdenv.targetPlatform }:

stdenv.mkDerivation rec {
  pname = "adguardhome";
  version = import ./version.nix;

  src = (import ./bins.nix fetchurl).${system};

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  meta = with lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = platforms.all;
    maintainers = with maintainers; [ numkem iagoq ];
    license = licenses.gpl3;
  };
}
