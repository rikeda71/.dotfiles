#!/bin/sh
# http://unskilled.site/powerline%E3%82%92%E5%B0%8E%E5%85%A5%E3%81%99%E3%82%8B/ 参考
# powerlineの導入
apt-get install automake
apt-get install libtool
curl -0 https://bootstrap.pypa.io/get-pip.py
python get-pip
git clone https://github.com/powerline/fonts.git
cp -r ~/fonts /usr/share/
fc-cache -fv
pip install --user git+git://github.com/powerline/powerline
sudo apt-get install socat
sudo pip install psutil
sudo pip install pyuv
