#! /bin/bash 
echo "######LXC的一键补丁脚本，使用方法确保utils文件夹在内核源码目录下，修改export KERNEL_DEFCONFIG=vendor/cmi_user_defconfig，为你机型的内核配置并运行此脚本，然后按一般方式构建内核######"
echo "           "

#手机的内核配置文件，一般在内核源码目录下的arch/arm64/configs或arch/arm64/configs/vendor下，一般为机型代号，高通骁龙处理器代号啥的，比如mi5 的为gemini_defconfig,一加8系列为kona_pref_defconfig,按实际情况修改
export KERNEL_DEFCONFIG=vendor/cmi_user_defconfig
#KERNEL_DEFCONFIG=vendor/xxxx_defconfig或KERNEL_DEFCONFIG=xxxx_defconfig                                                                           
export GKI_ROOT=$(pwd)


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

echo "         "
echo "运用补丁完成，请按一般方式构建内核"
echo "         "
