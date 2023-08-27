#! /bin/bash 
echo "######LXC的一键编译脚本######"
echo "           "

echo "           "
echo "           "
echo "设置编译环境"
echo "           "
echo "           "

#手机的内核配置文件，一般在内核源码目录下的arch/arm64/configs或arch/arm64/configs/vendor下，一般为机型代号，高通骁龙处理器代号啥的，比如mi5 的为gemini_defconfig,一加8系列为kona_pref_defconfig,按实际情况修改
export KERNEL_DEFCONFIG=vendor/cmi_user_defconfig
#KERNEL_DEFCONFIG=vendor/xxxx_defconfig或KERNEL_DEFCONFIG=xxxx_defconfig                                                                            #机型
export NAME=Mi10


#内核产品的格式类型通常为Image或 Image.gz.dtb，Image.gz等，默认Image
export KERNEL=Image

#env
#clang版本11 , binutils版本2.27
export GKI_ROOT=$(pwd)
export ARCH=arm64
export SUBARCH=arm64
export PATH="/root/Toolchain/clang-r383902b/bin:/root/Toolchain/google_gcc-4.9/bin:$PATH"

args="-j4 \
ARCH=arm64 \
SUBARCH=arm64 \
O=out \
CC=clang \
CROSS_COMPILE=aarch64-linux-android- \
CROSS_COMPILE_ARM32=arm-linux-androideabi- \
CLANG_TRIPLE=aarch64-linux-gnu- "



echo "        "
echo "环境清理"
echo "        "
make clean && make mrproper
rm -rf $GKI_ROOT/KernelSU $GKI_ROOT/out $GKI_ROOT/kernel.log $GKI_ROOT/drivers/kernelsu
mkdir -p out

echo "         "
echo "#添加LXC配置,到内核"
echo "         "

echo "CONFIG_DOCKER=y" >> "$GKI_ROOT/arch/arm64/configs/${KERNEL_DEFCONFIG}"

sed -i '/CONFIG_ANDROID_PARANOID_NETWORK/d' "$GKI_ROOT/arch/arm64/configs/${KERNEL_DEFCONFIG}"

echo "# CONFIG_ANDROID_PARANOID_NETWORK is not set" >> "$GKI_ROOT/arch/arm64/configs/${KERNEL_DEFCONFIG}"

sed -i '/CONFIG_LOCALVERSION/d' "$GKI_ROOT/arch/arm64/configs/${KERNEL_DEFCONFIG}"

echo 'CONFIG_LOCALVERSION="-LXC-KernelSU-support_Pdx"' >> "$GKI_ROOT/arch/arm64/configs/${KERNEL_DEFCONFIG}"

echo "         "
echo "         "
echo "#添加LXC,到内核树,并运用补丁"
echo "         "
echo "         "
DRIVER_KCONFIG=$GKI_ROOT/Kconfig
cp /root/Toolchain/utils $GKI_ROOT/ -R

echo 'source "utils/Kconfig"' >> "$GKI_ROOT/Kconfig"

sh $GKI_ROOT/utils/runcpatch.sh $GKI_ROOT/kernel/cgroup/cgroup.c


if [ -f $GKI_ROOT/net/netfilter/xt_qtaguid.c ]; then
       patch -p0 < $GKI_ROOT/utils/xt_qtaguid.patch
fi


echo "           "
echo "#build 构建内核,请耐心等待"
echo "           "
#内核将在 out/arch/arm64/boot下生成通常为Image或 Image.gz.dtb
make ${args} ${KERNEL_DEFCONFIG}
make ${args} 2>&1 | tee kernel.log



# 打包内核，用AnyKernel3进行打包,最终内核成品在 /mnt目录下
if [ -f $GKI_ROOT/out/arch/${ARCH}/boot/${KERNEL} ]
	then
		cp -rf $GKI_ROOT/out/arch/${ARCH}/boot/${KERNEL} /root/Toolchain/AnyKernel3 ;

                cp -rf $GKI_ROOT/out/arch/${ARCH}/boot/dtbo.img /root/Toolchain/AnyKernel3 ;
		cd /root/Toolchain/AnyKernel3 ;
		zip -r kernel-KernelSU-${NAME}_`date '+%Y%m%d%H%M'`.zip  . ;
		mv *.zip /mnt ;
		rm ${KERNEL} dtbo.img ;
		echo "           "
		echo "           "
		echo "build kernel success, the kernel products is /mnt"
		echo "成功构建内核，并打包好最终内核产品在 /mnt目录下，请用twrp或ex内核管理器刷写内核，并验证"
		echo "           "
                echo "           "
	else
	        echo "           "
	        echo "           "
	        echo "build kernel failed ,please check the kernel.log"
                echo "构建内核失败，请检查编译日志kernel.log"

        fi
