# install lightdm greeter
mkdir -p "${destination}"/etc/riscv
cp -R "${SRC}"/packages/blobs/desktop/lightdm "${destination}"/etc/riscv

# install default desktop settings
mkdir -p "${destination}"/etc/skel
chmod +x "${SRC}"/packages/blobs/desktop/skel/.icewm/startup
cp -R "${SRC}"/packages/blobs/desktop/skel/. "${destination}"/etc/skel

# install logo for login screen
mkdir -p "${destination}"/usr/share/pixmaps/riscv
cp "${SRC}"/packages/blobs/desktop/icons/riscv.png "${destination}"/usr/share/pixmaps/riscv

# install desktop wallpapers
mkdir -p "${destination}"/usr/share/backgrounds/riscv/
cp "${SRC}"/packages/blobs/desktop/desktop-wallpapers/*.jpg "${destination}"/usr/share/backgrounds/riscv/

# install lightdm wallpapers
mkdir -p "${destination}"/usr/share/backgrounds/lightdm/
cp "${SRC}"/packages/blobs/desktop/lightdm-wallpapers/*.jpg "${destination}"/usr/share/backgrounds/lightdm/
