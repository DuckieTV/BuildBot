#!/bin/bash
export PATH="${PATH}:/usr/local/bin/:/usr/bin"
rm -rf /var/www/deploy/standalone
rm -rf /var/www/deploy/newtab
rm -rf /var/www/deploy/browseraction
rm -rf /var/www/deploy/cordova
rm -rf /var/www/deploy/osx
rm -rf /var/www/deploy/binaries/*.*
rm -rf /var/www/deploy/TMP
rm -rf /var/www/Nightlies
cp -r /var/www/DuckieTV /var/www/Nightlies
DTREV=$(date +"%Y%m%d")
echo "set VERSION to ${DTREV}"
echo "$DTREV" > /var/www/Nightlies/VERSION
echo "Executing GULP"
cd /var/www/Nightlies
gulp
gulp nightly
rm -rf /var/www/deploy/TMP/
echo "Building"
cd /var/www/Nightlies/build/
./pack.sh --osx