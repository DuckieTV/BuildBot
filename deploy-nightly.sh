#!/bin/bash

source "${PWD}/.credentials"

DT=$(date +"%m%d%Y")
DTREV=$(date +"%Y%m%d")
cd /var/www/Nightlies/
curl https://api.github.com/repos/DuckieTV/Nightlies/releases\?access_token\=${GITHUB_API_KEY}  -o "/root/current_release.json"
LASTTAG=`jq -r '.[].tag_name' /root/current_release.json | head -n 2 | tail -n 1`
curl https://api.github.com/repos/DuckieTV/Nightlies/commits/tags/${LASTTAG} -o '/root/last_tag.json'
echo curl https://api.github.com/repos/DuckieTV/Nightlies/commits/tags/${LASTTAG} -o '/root/last_tag.json'
LASTCOMMIT=`jq -r '.parents[0].sha' /root/last_tag.json`
LOG=`git log "${LASTCOMMIT}"..HEAD --oneline|awk 1 ORS='\\\n - '`
LOG=${LOG//$'\n'/}
LOG="$(echo "${LOG}"|tr -d '"')"
LOG=${LOG%$' - '}
echo "LOG: ${LOG}, LAST TAG: ${LASTTAG},LAST COMMIT: ${LASTCOMMIT}"
cd /var/www/Nightlies/build/
DAT=$(date +"%m-%d-%Y")
PRETTYDATE=$(date +"%B %d, %Y")
API=`printf '{"tag_name": "nightly-%s","target_commitish": "master","name": "Nightly release for %s","body": "DuckieTV nightly release for %s.\\\n**Changelog:**\\\n - %s","draft": false, "prerelease": true}' "$DT" "$DAT" "$PRETTYDATE" "$LOG"`
echo "${API}"
#create new release
rm lastest_release.json
echo "Pushing new release"
curl https://api.github.com/repos/DuckieTV/Nightlies/releases?access_token=$GITHUB_API_KEY --data "$API" -o "/root/latest_release.json"
#cat /root/latest_release.json

ID=$(jq ".id" /root/latest_release.json)

#wget https://build.phonegap.com/apps/1473540/download/android -O "/var/www/deploy/binaries/DuckieTV-$DTREV-android.apk"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-Windows-ia32.exe" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-windows-x32.exe"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-Windows-x64.exe" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-windows-x64.exe"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-OSX-x64.pkg" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-OSX-x64.pkg"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-android.apk" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-android.apk"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-Chrome-BrowserAction.zip" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-chrome-browseraction.zip"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-Chrome-NewTab.zip" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-chrome-newtab.zip"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/TMP/DuckieTV_${DTREV}_i386.deb" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-ubuntu-x32.deb"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/TMP/DuckieTV_${DTREV}_amd64.deb" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-ubuntu-x64.deb"
echo "\n\n Done."
