#!/usr/bin/env bash

 #
 # Script For Building Android Kernel
 #

# Specify Kernel Directory
KERNEL_DIR="$(pwd)"

DEFCONFIG=vendor/xiaomi/alioth.config

# Files
IMAGE=$(pwd)/out/arch/arm64/boot/Image
DTBO=$(pwd)/out/arch/arm64/boot/dtbo.img
# DTB=$(pwd)/out/arch/arm64/boot/dtb.img
OUT_DIR=$(pwd)/out/
GORHANHEE=$(pwd)/gorhanhee/
#dts_source=arch/arm64/boot/dts/vendor/qcom

# Verbose Build
# VERBOSE=0
		       
# Export ARCH and SUBARCH
export ARCH=arm64
export SUBARCH=arm64
export PATH="${KERNEL_DIR}/clang/bin:$PATH"
export LINKER="ld.lld"

mkdir out
mkdir gorhanhee

# Compile
make -j16 O=${OUT_DIR} mrproper
make -j16 O=${OUT_DIR} CC=clang ARCH=arm64 vendor/kona-perf_defconfig vendor/xiaomi/sm8250-common.config vendor/kernelsu.config vendor/debugfs.config vendor/xiaomi/alioth.config
	       make -j16 O=${OUT_DIR} \
	       ARCH=arm64 \
	       LLVM=1 \
	       LLVM_IAS=1 \
	       CROSS_COMPILE=aarch64-linux-gnu- \
	       CROSS_COMPILE_COMPAT=arm-linux-gnueabi- || exit 1
	       
# Make Valid File	       
cp "${IMAGE}" "${KERNEL_DIR}/AIK/split_img/boot.img-kernel"
cd ${KERNEL_DIR}/AIK
./repackimg.sh

cd ${KERNEL_DIR}

cp "${KERNEL_DIR}/AIK/image-new.img" "$GORHANHEE/boot.img"

cp "${DTBO}" "$GORHANHEE/dtbo.img"
