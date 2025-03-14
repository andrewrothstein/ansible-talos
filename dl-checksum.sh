#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/siderolabs/talos/releases/download

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local dotexe=${4-}
    local platform="${os}-${arch}"

    # https://github.com/siderolabs/talos/releases/download/v1.7.6/talosctl-darwin-amd64
    local url="${MIRROR}/v${ver}/talosctl-${platform}${dotexe}"
    local lfile="${DIR}/talosctl-${ver}-${platform}${dotexe}"

    if [ ! -e $lfile ];
    then
        curl -sSLf -o "${lfile}" "${url}"
    fi

    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dl_ver () {
    local ver=$1

    printf "  %s:\n" $ver
    dl $ver darwin amd64
    dl $ver darwin arm64
    dl $ver freebsd amd64
    dl $ver freebsd arm64
    dl $ver linux amd64
    dl $ver linux arm64
    dl $ver linux armv7
    dl $ver windows amd64 .exe
}

dl_ver ${1:-1.9.5}
