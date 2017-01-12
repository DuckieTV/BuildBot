#!/bin/bash
export PATH="${PATH}:/usr/local/bin/:/usr/bin"
export DISPLAY=:1
rm -rf /var/www/deploy/standalone
rm -rf /var/www/deploy/newtab
rm -rf /var/www/deploy/browseraction
rm -rf /var/www/deploy/cordova
rm -rf /var/www/deploy/osx
rm -rf /var/www/deploy/binaries/*.*
rm -rf /var/www/deploy/TMP
rm -rf /var/www/Nightlies
git clone git@github.com:SchizoDuckie/DuckieTV.git /var/www/Nightlies
ln -s /var/www/DuckieTV/node_modules /var/www/Nightlies/node_modules
cd /var/www/Nightlies
git remote add nightly git@github.com:DuckieTV/Nightlies.git
DTREV=$(date +"%Y%m%d")
echo "set VERSION to ${DTREV}"
echo "$DTREV" > /var/www/Nightlies/VERSION
echo "Executing GULP"
gulp
gulp nightly
echo "Committing changes"
git add .
git commit -m "Auto-Build: ${DTREV}"
git tag -am "nightly-${DTREV}" "nightly-${DTREV}"
echo "Pushing"
git push nightly angular:master -f --tags
rm -rf /var/www/deploy/TMP/
echo "Building"
cd /var/www/Nightlies/build/
./pack.sh --all
cd /var/www/deploy/
zip -r "binaries/DuckieTV-${DTREV}-Chrome-BrowserAction.zip" browseraction
zip -r "binaries/DuckieTV-${DTREV}-Chrome-NewTab.zip" newtab
