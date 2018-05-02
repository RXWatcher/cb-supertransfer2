#!/bin/bash
# This script assumes you named your Service accounts like: ^GDSA[0-9]+$
# example: GDSA1 ... GDSA2 ... GDSA99
#
# EXAMPLE: the json key named derpyderp-8e3ec71f927d.json with the email:
# gdsa10@derpyderp-92374.iam.gserviceaccount.com
# will be renamed to gdsa10.json
# this is completely optional, but helps keep track if you made a lot of keys
#
# usage: place script in folder full of json keys
# this directory is in: /opt/appdata/plexguide/supertransfer
# (which is also where keys get dropped if using the web client to upload)
#
# cd /opt/scripts/supertransfer2
# ./auto-rename-my-keys.sh

[[ ! $(ls /opt/supertransfer2 | egrep .\.json$ ) ]] && echo no json keys found in this dir && exit 1

read -p 'would you like to do a dry run?' answer
[[ $answer =~ [y|Y] ]] && dryrun=1

mkdir /opt/supertransfer2/processed_keys
for file in /opt/supertransfer2/*.json ; do
 rename=$(egrep client_email $file | cut -f4 -d'"' | cut -c1-6 | sed 's/-//g')
 if [[ -n $dryrun ]]; then
    echo $file will be renamed to ${rename}.json
 else
   if [[ $(pwd) == '/opt/supertransfer2/' ]]; then
    mv $file ${rename}.json -v
   else
    mv $file /opt/supertransfer2/processed_keys/${rename}.json -v
    tar -cvf /opt/supertransprocessed_keys.tar processed_keys
    echo "Processed keys ready. To extract: (optional)"
    echo "tar -xvf /opt/supertransfer2/processed_keys.tar "
  fi
 fi
done

exit 0
