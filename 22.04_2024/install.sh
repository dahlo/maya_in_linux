# update system before starting
sudo apt update ; sudo apt upgrade -y

# download maya 2024, link from https://github.com/tahv/docker-mayapy/blob/main/2024/Dockerfile
wget --no-check-certificate -O maya.tgz https://efulfillment.autodesk.com/NetSWDLD/2024/MAYA/537B71D7-A391-3E25-93C3-9967181B3F34/ESD/Autodesk_Maya_2024_Linux_64bit.tgz 

# unpack
mkdir install ; cd install
tar -xzvf maya.tgz

# convert rpms to deb
cd Packages
alien -vc *.rpm

# install licensing, according to https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/4EQDDcHqJbfBkQr3i0FrbQ.html
sudo apt-get install ./adlmapps28_28.0.11-1_amd64.deb
sudo apt-get install ./adskflexnetserveripv6_11.18.0-1_amd64.deb
sudo apt-get install ./adskflexnetclient_11.18.0-1_amd64.deb
sudo apt-get install ./adsklicensing13.0.0.8122_0-1_amd64.deb

# check that the license server is running
sudo systemctl status adsklicensing

# install maya
sudo apt-get install ./maya2024-64_2024.0-4641_amd64.deb

# check if it is registered in the license server
/opt/Autodesk/AdskLicensing/Current/helper/AdskLicensingInstHelper list

# add it manually
sudo /opt/Autodesk/AdskLicensing/Current/helper/AdskLicensingInstHelper register -pk 657P1 -pv 2024.0.0.F -el EN_US -cf /var/opt/Autodesk/Adlm/Maya2024/MayaConfig.pit

# get and install libXp6
sudo add-apt-repository ppa:zeehio/libxp
sudo apt-get update
sudo apt-get install libxp6

# add additional dependencies
sudo apt-get install libfam0 libcurl4 libpcre16-3 libjpeg62 libxm4 libgdbm-compat4 libmng2 libaudiofile-dev xfonts-100dpi xfonts-75dpi
sudo apt-get install --reinstall libxcb-xinerama0
sudo ln -s /usr/lib/x86_64-linux-gnu/libgdbm_compat.so.4 /usr/autodesk/maya2024/lib/libgdbm.so.4
sudo ln -s /usr/lib/x86_64-linux-gnu/libmng.so.2 /usr/autodesk/maya2024/lib/libmng.so.1
xset +fp /usr/share/fonts/X11/100dpi
xset +fp /usr/share/fonts/X11/75dpi
xset fp rehash

# install libffi6
wget -O libffi6.deb http://archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-8_amd64.deb 
sudo apt-get install ./libffi6.deb

# install libpng15
cd /tmp
wget https://sourceforge.net/projects/libpng/files/libpng15/older-releases/1.5.15/libpng-1.5.15.tar.gz
tar -zxvf ./libpng-1.5.15.tar.gz
cd libpng-1.5.15
./configure --prefix=/usr/local/libpng
make check
sudo make install
make check
sudo ln -s /usr/local/libpng/lib/libpng15.so.15 /usr/autodesk/maya2024/lib/libpng15.so.15

# set environent variables
mkdir -p ~/maya/2024/ && touch ~/maya/2024/Maya.env
echo "MAYA_DISABLE_ADP=1" >> ~/maya/2024/Maya.env
echo "LC_ALL=C" >> ~/maya/2024/Maya.env

# start maya
maya





