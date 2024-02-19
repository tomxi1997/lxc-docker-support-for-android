# Enable kernel options for Docker

Add a simple option for enabling all the requirements for Docker to run.

## Install

1. Create a folder inside your kernel source tree, for example `utils`, then
place the Kconfig in there.
2. Add a line into the root Kconfig: `source "utils/Kconfig"`.

Sample final Kconfig:

    #
    # For a description of the syntax of this configuration file,
    # see Documentation/kbuild/kconfig-language.txt.
    #
    mainmenu "Linux/$ARCH $KERNELVERSION Kernel Configuration"

    config SRCARCH
            string
            option env="SRCARCH"

    source "utils/Kconfig"

    source "arch/$SRCARCH/Kconfig"


Now enable the Docker support option:

    Utilities --->
      [*] Docker support

And you should be good to go. Compile the kernel, install, reboot, enjoy.

## Credits

List created using information from the [Gentoo Docker Project](https://wiki.gentoo.org/wiki/Docker).






下面的所有操作可由此
https://github.com/tomxi1997/LXC_KernelSU_Action
一键编译生成lxc kernelsu内核，手动操作的可看下面↓

11.1 #lxc配置添加到内核源码，在内核源码目录下执行


git clone https://github.com/tomxi1997/lxc-docker-support-for-android.git utils

git clone https://github.com/tomxi1997/AnyKernel3.git



11.2 #在内核源码根目录,编辑Kconfig

添加以下内容，可参考2. Add a line into the root Kconfig样式修改

source "utils/Kconfig"

22。参照utils下的补丁文件进行修改，fix_cgroup.patch，fix_panic.patch
主要修改以下这两个文件
kernel/cgroup/cgroup.c
net/netfilter/xt_qtaguid.c 


33。然后在内核的配置文件，按你机型的实际配置来修改。#手机的内核配置文件，一般在内核源码目录下的arch/arm64/configs或arch/arm64/configs/vendor下，一般为机型代号，高通骁龙处理器代号啥的，比如mi5 的为gemini_defconfig,一加8系列为kona_pref_defconfig,按实际情况修改。

在arch/arm64/configs/xxxx_defconfig
中加入以下内容


#  CONFIG_ANDROID_PARANOID_NETWORK is not set
CONFIG_DOCKER=y


44。按照一般方式重新编译内核，用AnyKernel3 打包后刷入内核，可用kernelsu action 来搞,可用这https://github.com/wu17481748/LXC-DOCKER-KernelSU_Action或实体机........

可参考我的酷安 ，但是对手机上chroot中使用的，实体电脑上也类似的，工具链选择 clang383902b +Google gcc4.9或clang-r416189+Google gcc4.9, 系统选择ubuntu20.04，
可最终效果演示
【在Android中运行LXC容器，Docker容器（需要刷入自定义内核）-哔哩哔哩】 https://b23.tv/yAR1IzO
到时我出一个在x86_64的编译教程。


对手机上chroot中编译内核
https://www.coolapk.com/feed/47142899?shareKey=ZDI2NjhhODliM2NkNjRlNWQ2NTg~&shareUid=25509431&shareFrom=com.coolapk.market_11.2.5

https://www.coolapk.com/feed/47357538?shareKey=M2Y5ZTYzMTc1NDJkNjRlNWQ2NGE~&shareUid=25509431&shareFrom=com.coolapk.market_11.2.5

https://www.coolapk.com/feed/47357987?shareKey=Y2Q3YjEzY2UyMmJhNjRlNWQ2M2U~&shareUid=25509431&shareFrom=com.coolapk.market_11.2.5


55。在magisk中刷入lxc模块，Lxc-Magisk-ubuntu22.04-arm64-base-release。运行lxc
下载链接
复制这段内容后打开天翼云盘手机App，操作更方便哦！链接：https://cloud.189.cn/t/J3mABrA3a2i2（访问码：be21）

66。最终效果
【在Android中运行LXC容器，Docker容器（需要刷入自定义内核）-哔哩哔哩】 https://b23.tv/yAR1IzO

相关参考
#Linux#
https://blog.qiuqiu233.top/post/1 

https://gist.github.com/FreddieOliveira/efe850df7ff3951cb62d74bd770dce27

https://github.com/grilix/kernel-docker-support

https://www.coolapk.com/feed/48613211?shareKey=MDljMWU3ZmQyNmQ1NjRlNWQ0NzU~&shareUid=25509431&shareFrom=com.coolapk.market_11.2.5

https://www.coolapk.com/feed/47377101

https://mirrors.tuna.tsinghua.edu.cn/help/lxc-images

https://unix.stackexchange.com/questions/442598/how-to-configure-systemd-resolved-and-systemd-networkd-to-use-local-dns-server-f


