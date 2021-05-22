#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch jq

# This file is based on /pkgs/servers/gotify/update.sh

set -euo pipefail

dirname="$(dirname "$0")"
bins="$dirname/bins.nix"

latest_release=$(curl --silent https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")

echo "got version $version"
echo "\"${version#v}\"" > "$dirname/version.nix"

declare -A systems
systems[linux_386]=i686-linux
systems[linux_amd64]=x86_64-linux
systems[linux_arm64]=aarch64-linux
systems[darwin_amd64]=x86_64-darwin

echo 'fetchurl:' > "$bins"
echo '{'        >> "$bins"

for asset in $(curl --silent https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | jq -c '.assets[]') ; do
    url="$(jq -r '.browser_download_url' <<< "$asset")"
    adg_system="$(egrep -o '(darwin|linux)_(386|amd64|arm64)' <<< "$url" || echo -n)"
    if [ -n "$adg_system" ]; then
        nix_system=${systems[$adg_system]}
        nix_src=$(nix-prefetch -s --output nix fetchurl --url $url)
        echo "\"$nix_system\" = fetchurl $nix_src;" >> $bins
    fi
done

echo '}' >> "$bins"

