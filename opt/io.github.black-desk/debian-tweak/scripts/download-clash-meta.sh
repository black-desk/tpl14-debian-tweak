#!/bin/bash

# This script is used to download the latest version of clash-meta.

set -x
set -e
set -o pipefail

CURL=${CURL:=curl}
JQ=${JQ:=jq}

REPO=${REPO:=MetaCubeX/mihomo}

ARCH=${ARCH:=amd64}

OUTPUT=${OUTPUT:=clash-meta}

function cleanup() {
	rv=$?

	if [ $rv -eq 0 ]; then
		return
	fi

	rm "$OUTPUT" -f

	return $rv
}

trap cleanup EXIT

VERSION=${VERSION:=$(
	${CURL} -s https://api.github.com/repos/"${REPO}"/releases/latest |
		jq -r .tag_name
)}

mkdir -p "$(dirname "$OUTPUT")"

curl -LJ "https://github.com/${REPO}/releases/download/${VERSION}/mihomo-linux-${ARCH}-${VERSION}.gz" |
	gunzip >"${OUTPUT}"