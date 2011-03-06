#!/bin/bash

#./configure --cc=agcc --enable-cross-compile --target-os=linux --arch=arm

if [ "$NDK" = "" ]; then
	export NDK=${HOME}/Projet_android/android-ndk-r5
	echo Using NDK path : ${NDK}
fi

SDK=$NDK/platforms/android-9/arch-arm
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86
export PATH=$TOOLCHAIN/bin:$PATH

EXTRA_CFLAGS="-I$SDK/usr/include -march=armv7-a -mfloat-abi=softfp -mfpu=vfp -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__ "
EXTRA_LDFLAGS="-Wl,-T,$NDK/toolchains/arm-eabi-4.4.0/prebuilt/linux-x86/arm-eabi/lib/ldscripts/armelf.x -Wl,--fix-cortex-a8,-dynamic-linker,/system/bin/linker -nostdlib $SDK/usr/lib/libc.so $SDK/usr/lib/libm.so -Wl,-rpath-link=$SDK/usr/lib -L$TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.4.3/"
EXTRA_EXE_LDFLAGS="$SDK/usr/lib/crtbegin_dynamic.o $SDK/usr/lib/crtend_android.o"
EXTRA_LIBS="-lgcc"

FLAGS="--target-os=linux --cross-prefix=arm-linux-androideabi- --arch=arm"
FLAGS="$FLAGS --prefix=build/ffmpeg"
#FLAGS="$FLAGS --soname-prefix=/data/data/com.bambuser.broadcaster/lib/"
FLAGS="$FLAGS --enable-shared"
FLAGS="$FLAGS --enable-small --optimization-flags=-O2"
#FLAGS="$FLAGS --disable-encoders --disable-decoders --disable-protocols --disable-muxers --disable-demuxers --disable-parsers --disable-devices --disable-filters --disable-bsfs"
FLAGS="$FLAGS --enable-encoder=mpeg2video"

#cd ffmpeg-git
rm -rf build/ffmpeg
mkdir -p build/ffmpeg
echo $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --extra-exe-ldflags="$EXTRA_EXE_LDFLAGS" --extra-libs="$EXTRA_LIBS" > build/ffmpeg/info.txt
./configure $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --extra-exe-ldflags="$EXTRA_EXE_LDFLAGS" --extra-libs="$EXTRA_LIBS" | tee build/ffmpeg/configuration.txt
[ $PIPESTATUS == 0 ] || exit 1
make clean
make -j4 || exit 1
make install || exit 1
