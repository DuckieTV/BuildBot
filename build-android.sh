#!/bin/bash

source "${PWD}/.credentials"

echo "Updating repo"
curl -u $PHONEGAP_USER:$PHONEGAP_PWD -X PUT -d 'data={"pull":"true"}' https://build.phonegap.com/api/v1/apps/1473540 > /dev/null
echo "Unlocking key"
curl -u $PHONEGAP_USER:$PHONEGAP_PWD -X PUT -d 'data={"keys":{"android": {"id":'$ANDROID_KEYSTORE_ID',"key_pw":"'$ANDROID_KEYSTORE_PWD'","keystore_pw":"'$ANDROID_KEYSTORE_PWD'"}}}' https://build.phonegap.com/api/v1/apps/1473540 > /dev/null
echo "Scheduling build."
curl -u $PHONEGAP_USER:$PHONEGAP_PWD -X POST -d '' https://build.phonegap.com/api/v1/apps/1473540/build > /dev/null
echo "Done!"
