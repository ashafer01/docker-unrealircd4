#!/bin/bash
set -e

cd /tmp/build

# get the latest unreal source
wget "https://www.unrealircd.org/unrealircd4/unrealircd-$UNREAL_VERSION.tar.gz"
tar -xzvf "unrealircd-$UNREAL_VERSION.tar.gz"
cd "unrealircd-$UNREAL_VERSION"

# configure the build
echo "#define FAKELAG_CONFIGURABLE" >> include/config.h
mv /tmp/build/config.settings .
./Config -quick

# build source
make
make install

# install maintainer script
mv /tmp/build/regen_cloak_keys.sh /opt/unreal
chown irc:irc /opt/unreal/regen_cloak_keys.sh
chmod 744 /opt/unreal/regen_cloak_keys.sh

# build deb

cd /tmp/deb
find /opt/unreal/conf -type f > DEBIAN/conffiles
find /opt/unreal -type f -printf '%p ' | xargs md5sum > DEBIAN/md5sums
mkdir opt
cp -a /opt/unreal opt/

dpkg -b /tmp/deb/ "/tmp/artifacts/ashafer01-unrealircd4_$UNREAL_VERSION.deb"
