#!/bin/bash
export PATH="${PATH}:/usr/local/bin/:/usr/bin"
rm -rf /var/www/deploy/standalone
rm -rf /var/www/deploy/newtab
rm -rf /var/www/deploy/browseraction
rm -rf /var/www/deploy/cordova
rm -rf /var/www/deploy/osx
rm -rf /var/www/deploy/binaries/*.*
rm -rf /var/www/deploy/TMP
cd /var/www/Nightlies
echo "nixing changes"
git reset --hard
echo "pulling latest duckietv"
git pull duckietv angular:master --force
DTREV=$(date +"%Y%m%d")
echo "set VERSION to ${DTREV}"
echo "$DTREV" > /var/www/Nightlies/VERSION
echo "Executing GULP"
gulp nightly
echo "Committing changes"
git add .
git commit -m "Auto-Build: ${DTREV}"
echo "Pushing"
git push origin master -f
rm -rf /var/www/deploy/TMP/
echo "Building"
cd /var/www/Nightlies/build/
./pack.sh --all
cd /var/www/deploy/
zip -r "binaries/DuckieTV-${DTREV}-Chrome-BrowserAction.zip" browseraction
zip -r "binaries/DuckieTV-${DTREV}-Chrome-NewTab.zip" newtab
