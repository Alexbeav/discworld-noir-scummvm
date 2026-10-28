#!/bin/bash
# Build the patched ScummVM (Tinsel only) for the Linux release.
# Runs INSIDE the Steam Runtime 3 "sniper" SDK, so the binary needs only glibc 2.31.
# Usage: build-in-sdk.sh <patched scummvm source> <output AppDir>
set -euo pipefail
SRC=$1
OUT=$2
JOBS=${JOBS:-4}

cd "$SRC"
./configure \
	--prefix=/usr \
	--disable-all-engines --enable-engine=tinsel \
	--enable-release --disable-debug \
	--enable-mad \
	--disable-gtk --disable-libcurl --disable-cloud --disable-sndio --disable-sdlnet \
	--disable-vorbis --disable-tremor --disable-flac --disable-jpeg \
	--disable-theoradec --disable-mpeg2 --disable-a52 --disable-faad \
	--disable-fluidsynth --disable-mikmod --disable-openmpt --disable-discord \
	--disable-tts --disable-eventrecorder --disable-mt32emu \
	--with-sdl-prefix=/usr
grep -q 'define USE_MAD' config.h || { echo "libmad not found: no music or speech" >&2; exit 3; }

make -j"$JOBS" LDFLAGS='-Wl,-rpath,\$$ORIGIN/../lib'
rm -rf "$OUT"
make install DESTDIR="$OUT"
strip "$OUT/usr/bin/scummvm"

# Bundle libmad: distributions rarely install it.
mkdir -p "$OUT/usr/lib"
cp -L /usr/lib/x86_64-linux-gnu/libmad.so.0 "$OUT/usr/lib/libmad.so.0"
