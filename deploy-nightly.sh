#!/bin/bash

source "${PWD}/.credentials"

DT=$(date +"%m%d%Y")
DTREV=$(date +"%Y%m%d")

cd /var/www/Nightlies/build/
DAT=$(date +"%m-%d-%Y")
PRETTYDATE=$(date +"%B %d, %Y")
API=`printf '{"tag_name": "nightly-%s","target_commitish": "master","name": "Nightly release for %s","body": "DuckieTV nightly release for %s","draft": false, "prerelease": true}' "$DT" "$DAT" "$PRETTYDATE"`

#create new release
curl https://api.github.com/repos/DuckieTV/Nightlies/releases?access_token=$GITHUB_API_KEY --data "$API" -o latest_release.json

ID=$(jq ".id" ./latest_release.json)

wget https://build.phonegap.com/apps/1473540/download/android -O "/var/www/deploy/binaries/DuckieTV-$DTREV-android.apk"

curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-win-ia32.zip" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-win32.zip"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-osx-ia32.zip" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-osx-ia32.zip"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-linux-x64.zip" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-linux-x64.zip"
curl -# -XPOST -H "Authorization:token $GITHUB_API_KEY" -H "Content-Type:application/octet-stream" --data-binary @"/var/www/deploy/binaries/DuckieTV-$DTREV-android.apk" "https://uploads.github.com/repos/DuckieTV/Nightlies/releases/$ID/assets?name=DuckieTV-$DT-android.apk"

echo "\n\n Done."
