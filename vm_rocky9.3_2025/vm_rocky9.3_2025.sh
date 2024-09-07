

# create dir
mkdir install ; cd install

# download  maya 2025
wget --no-check-certificate -O maya.tgz https://efulfillment.autodesk.com/NetSWDLD/2025/MAYA/1AAEB4DA-FE7D-3C8A-A4F4-C217F55C55BA/ESD/Autodesk_Maya_2025_Linux_64bit.tgz

# unpack
tar -xzvf maya.tgz

# enable epel
sudo dnf config-manager --set-enabled crb
sudo dnf install epel-release
sudo dnf clean all
sudo dnf check-update

# update system
sudo dnf update -y

# installer needs libnsl
sudo dnf install -y libnsl

# install additional deps

# General Packages
sudo dnf install -y glibc libSM libICE zlib openssl-libs nss dbus # lsb-core libpcre16
sudo dnf install -y lsb_release # instead of lsb-core
sudo dnf install -y  libpcre16.so.0 # instead of libpcre16

# Multimedia Packages
sudo dnf install -y mesa-libGLU mesa-libGLw audiofile-devel e2fsprogs-libs libcap libdrm libmng flite speech-dispatcher cups libpng15 # gamin
sudo dnf install -y   # instead of gamin


# X Window – Xcb – X11 Packages
sudo dnf install -y libXau libXcomposite libXcursor libXext libXfixes libXi libXmu libXp libXrandr libXrender libXScrnSaver libxshmfence libXt libXtst libXinerama libxcb xcb-util xcb-util-wm xcb-util-image xcb-util-keysyms xcb-util-renderutil libxkbcommon libxkbcommon-x11 libX11

# Fonts
sudo dnf install -y fontconfig freetype xorg-x11-fonts-ISO8859-1-75dpi xorg-x11-fonts-ISO8859-1-100dpi liberation-mono-fonts liberation-fonts-common liberation-sans-fonts liberation-serif-fonts

# additional deps not mentioned in the official guide
sudo dnf install libpng15 libpcre16.so.0 libGLU.so.1 libGLU xorg-x11-fonts-ISO8859-1-100dpi xorg-x11-fonts-ISO8859-1-75dpi libglvnd-opengl xcb-util-cursor

# run install
cd install
./Setup

# start maya
maya
# without home screen
MAYA_NO_HOME=1 maya
