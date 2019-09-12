#!/bin/bash
files=$(shopt -s nullglob dotglob; echo /data/av/queue/*)
if (( ${#files} ))
then
    printf "Found files to process\n"
    for file in "/data/av/queue"/* ; do
        filename=`basename $file`
        cp $file "/data/av/scan/${filename}"
        printf "Processing /data/av/scan/${filename}\n"
        /usr/local/bin/scanfile.sh > /data/av/scan/info 2>&1
        if [ -e "/data/av/scan/${filename}" ]
        then
            printf "  --> File ok\n"
            rm -f "/data/av/scan/${filename}"
            rm /data/scan/info
        elif [ -e "/data/av/quarantine/${filename}" ]
        then
            printf "  --> File quarantined / nok\n"
            mv -f "/data/av/scan/info" "/data/av/nok/${filename}"
            chmod 000 "/data/av/queue/${filename}"
            printf "  --> Scan report moved to /data/av/nok/${filename}\n"
        fi
    done
    printf "Done with processing\n"
fi
