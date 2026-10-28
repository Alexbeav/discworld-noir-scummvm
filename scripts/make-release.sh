#!/bin/bash
# Make the Linux release tarball.
# Needs: git, bwrap, a ScummVM clone, and the Steam Runtime 3 "sniper" SDK sysroot from
# https://repo.steampowered.com/steamrt-images-sniper/snapshots/ (tested: 3.0.20261021.266025)
# with Debian 11's libmad0 and libmad0-dev 0.15.1b-10 unpacked into it.
# Usage: make-release.sh <scummvm clone> <sdk sysroot> <work dir>
set -euo pipefail
REPO=$(cd "$(dirname "$0")/.." && pwd)
SCUMMVM=$(cd "$1" && pwd)
SYSROOT=$(cd "$2" && pwd)
WORK=$3
BASE=e8623090f959870ce5c39b01a2698a3653158653
NAME=discworld-noir-scummvm-linux-x86_64

mkdir -p "$WORK"
WORK=$(cd "$WORK" && pwd)
rm -rf "$WORK/src" "$WORK/AppDir" "$WORK/$NAME"
mkdir "$WORK/src"
git -c safe.directory='*' -C "$SCUMMVM" archive "$BASE" | tar -x -C "$WORK/src"
(cd "$WORK/src" && git apply "$REPO/noir.patch")

bwrap --bind "$SYSROOT" / --dev /dev --proc /proc --tmpfs /tmp \
	--bind "$WORK" /work --ro-bind "$REPO/scripts" /scripts \
	--setenv PATH /usr/bin:/bin --setenv HOME /tmp --unshare-all --die-with-parent \
	/bin/bash /scripts/build-in-sdk.sh /work/src /work/AppDir

mkdir "$WORK/$NAME"
cp -a "$WORK/AppDir/usr" "$WORK/$NAME/"
install -m 755 "$REPO/scripts/noir-scummvm" "$WORK/$NAME/noir-scummvm"
cp "$REPO/README.md" "$REPO/COPYING" "$WORK/$NAME/"
tar -C "$WORK" -czf "$WORK/$NAME.tar.gz" "$NAME"
sha256sum "$WORK/$NAME.tar.gz"
