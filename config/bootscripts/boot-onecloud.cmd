# DO NOT EDIT THIS FILE
#
# Please edit /boot/armbianEnv.txt to set supported parameters
#

# We can't use `test -z` due to the bug: https://lists.denx.de/pipermail/u-boot/2005-August/011447.html
if test -n "${bootdev}"; test $? != 0; then
	echo '=============================================================='
	echo 'Please set "bootdev" before calling this script.'
	echo ''
	echo 'Boot from usb:'
	echo '  setenv bootdev "usb 0"'
	echo '  usb start'
	echo '  fatload ${bootdev} 0x20800000 boot.scr && autoscr 0x20800000'
	echo ''
	echo 'Boot from eMMC:'
	echo '  setenv bootdev "mmc 1"'
	echo '  fatload ${bootdev} 0x20800000 boot.scr && autoscr 0x20800000'
	echo '=============================================================='
	exit 22
fi

echo "Try to boot from ${bootdev}"

fatload ${bootdev} 0x20800000 /armbianEnv.txt && env import -t 0x20800000 ${filesize}

if test -n "${rootdev}"; test $? != 0; then
	echo 'Please set "rootdev" before calling this script'
	echo 'or set it in armbianEnv.txt.'
	exit 22
fi

if test -n "${consoleargs}"; test $? != 0; then
	test -n "${console}" || setenv console "both"

	setenv consoleargs ""
	# Due to https://github.com/systemd/systemd/issues/9899, only the last
	#   console will be the primary console (/dev/console) which is the
	#   only console the initramfs shell and the systemd log use.
	# So when set "both", we use serial console as the primary console.
	test "${console}" = "display" || test "${console}" = "both" && setenv consoleargs "${consoleargs} console=tty1"
	test "${console}" = "serial" || test "${console}" = "both" && setenv consoleargs "${consoleargs} console=ttyAML0,115200n8"
	setenv consoleargs "${consoleargs} no_console_suspend consoleblank=0"

	test -n "${bootlogo}" || setenv bootlogo "false"
	if test "${bootlogo}" = "true"; then
		setenv consoleargs "${consoleargs} splash plymouth.ignore-serial-consoles"
	else
		setenv consoleargs "${consoleargs} splash=verbose"
	fi
fi

# Boot Arguments
setenv bootargs ""
setenv bootargs "${bootargs} root=${rootdev} rootwait rw"
setenv bootargs "${bootargs} ${consoleargs}"
setenv bootargs "${bootargs} ${extraargs}"

# Booting
fatload ${bootdev} 0x20800000 /uImage || exit 1
fatload ${bootdev} 0x22000000 /uInitrd || exit 1
fatload ${bootdev} 0x21800000 /dtb/meson8b-onecloud.dtb || exit 1

bootm 0x20800000 0x22000000 0x21800000

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr
