#!/bin/bash

# check that NDK path is define in env variables
if [ -z "$NDK" ]
then
	echo "You need to define 'NDK' variable in your environnement variables with NDK path to compile ffmpeg"
	exit 1 
fi

# check that there is at least one parameter
if [ $# != 1 ]
then
	echo "Need to set in parameter the architecture for which you want to compile ffmpeg : 'x86', 'ARMv6' or 'ARMv7'"
	exit 1 
fi

# Optimization flags
EXTRA_CFLAGS="-ffast-math -pipe -O2 -ftree-vectorize"

if [ $1 == "ARMv6" ]
then
	# ARM v6
	SYSROOT="$NDK/platforms/android-14/arch-arm/"
	TOOLCHAIN="$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64"
	ARCH="arm"
	CROSSPREFIX="$TOOLCHAIN/bin/arm-linux-androideabi-"
	CPU="armv6"
	EXTRA_CFLAGS="$EXTRA_CFLAGS -mfpu=vfp -mfloat-abi=softfp "
elif [ $1 == "ARMv7" ]
then
	#ARM v7
	SYSROOT="$NDK/platforms/android-14/arch-arm/"
	TOOLCHAIN="$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64"
	ARCH="arm"
	CROSSPREFIX="$TOOLCHAIN/bin/arm-linux-androideabi-"
	CPU="armv7-a"
	EXTRA_CFLAGS="$EXTRA_CFLAGS -mfpu=neon -mfloat-abi=softfp "
	# neon is an alias for neon-vfpv3
	# with mfpu=neon, we must add -funsage-math-optimizations to generate NEON code because NEON hardware does not fully implement the IEEE 754
	# but -funsage-math-optimizations is already include with --ffast-math
elif [ $1 == "x86" ]
then
	# x86
	SYSROOT="$NDK/platforms/android-14/arch-x86/"
	TOOLCHAIN="$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64"
	ARCH="x86"
	CPU="i686"
	CROSSPREFIX="$TOOLCHAIN/bin/i686-linux-android-"
	EXTRA_CFLAGS="$EXTRA_CFLAGS -m32 -mfpmath=sse -msse"
	# m32 sets int, long and pointer types to 32 bits
	# mfpmath=sse use scalar floating point instructions
else
	echo "Available architectures are 'x86', 'ARMv6' or 'ARMv7'"
	exit 0 
fi

./configure --enable-cross-compile --target-os=linux --arch=$ARCH --cpu=$CPU --cross-prefix=$CROSSPREFIX --disable-static --enable-shared --sysroot=$SYSROOT --extra-cflags="$EXTRA_CFLAGS" \
	--disable-symver \
        --disable-debug \
        --disable-avdevice \
        --disable-avfilter \
        --disable-swscale \
        --disable-ffmpeg \
        --disable-ffplay \
        --disable-ffserver \
        --disable-network \
        --disable-ffprobe \
        --disable-muxers \
        --disable-demuxers \
        --enable-demuxer=aac \
        --enable-demuxer=flac \
        --enable-demuxer=mp3 \
        --enable-demuxer=wav \
        --enable-demuxer=mov \
        --enable-demuxer=asf \
        --disable-bsfs \
        --disable-filters \
        --disable-parsers \
        --enable-parser=aac \
        --enable-parser=aac_latm \
        --enable-parser=mpegaudio \
        --disable-protocols \
        --enable-protocol=file \
        --disable-indevs \
        --disable-outdevs \
        --disable-encoders \
        --disable-decoders \
        --enable-decoder=aac \
        --enable-decoder=alac \
        --enable-decoder=aac_latm \
        --enable-decoder=flac \
        --enable-decoder=mp1 \
        --enable-decoder=mp2 \
        --enable-decoder=mp3 \
        --enable-decoder=wmav1 \
        --enable-decoder=wmav2 \
        --enable-decoder=pcm_s16le \
        --enable-decoder=pcm_s16be \
        --disable-decoder=h264_cuvid \
        --disable-decoder=hevc_cuvid \
        --disable-decoder=mjpeg_cuvid \
        --disable-decoder=mp1 \
        --disable-decoder=vc1_cuvid \
        --disable-decoder=vp8_cuvid \
        --disable-decoder=vp9_cuvid \
        --disable-hwaccels

# clean all previous compiled files
make clean

# compile with 4 cores
make -j4

#copy all .so files in HOME directory
find -name '*.so' -exec cp  {} ~/ \; # {} contains the name of the found file, ';' is part of the command so we need to escape it

exit 0