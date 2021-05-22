{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "adguardhome";
  version = "0.106.3";

  src = fetchurl {
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v${version}/AdGuardHome_linux_amd64.tar.gz";
    sha256 = "sha256-qJMymTxmoPlIhuJD6zFBWWwzz+CFx+9+MOrRiFtA4IY=";
  };

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  meta = with lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = platforms.linux;
    maintainers = with maintainers; [ numkem iagoq ];
    license = licenses.gpl3;
  };
}
