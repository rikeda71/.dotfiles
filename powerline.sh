#!/bin/sh
# http://unskilled.site/powerline%E3%82%92%E5%B0%8E%E5%85%A5%E3%81%99%E3%82%8B/ 参考
# powerlineの導入
apt-get install automake
apt-get install libtool
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
git clone https://github.com/powerline/fonts.git
cp -r ~/fonts /usr/share/
fc-cache -fv
pip install --user git+git://github.com/powerline/powerline
apt-get install socat
pip install psutil
pip install pyuv
sh /usr/share/fonts/install.sh
find ~/.local/lib/ -type d -exec chmod 755 {} \;
