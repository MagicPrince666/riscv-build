# DO NOT EDIT THIS FILE
#
# Please edit /boot/armbianEnv.txt to set supported parameters
#

# default values
setenv rootdev "/dev/mmcblk1p1"
setenv verbosity "1"
setenv rootfstype "ext4"

setenv fdt_name /boot/dtb/marvell/armada-8040-mcbin.dtb
setenv initrd_image /boot/uInitrd
setenv image_name /boot/Image

load mmc 1:1 ${scriptaddr} /boot/armbianEnv.txt
env import -t ${scriptaddr} ${filesize}

setenv bootargs "$console root=${rootdev} rootfstype=${rootfstype} rootwait loglevel=${verbosity} $extra_params $cpuidle"

ext4load mmc 1:1 $kernel_addr_r $image_name
ext4load mmc 1:1 $initrd_addr_r $initrd_image
ext4load mmc 1:1 $fdt_addr_r $fdt_name

booti $kernel_addr_r $initrd_addr_r $fdt_addr_r
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr
