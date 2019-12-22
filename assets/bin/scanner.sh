#!/bin/bash

while true; do
    printf "Checking for files to process\n"
    for file in "/data/av/queue"/* ; do
<<<<<<< HEAD
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
=======
         if [ -f "$file" ];then
            filename=`basename $file`
            mv -f $file "/data/av/scan/${filename}"
            printf "Processing /data/av/scan/${filename}\n"
            /usr/local/bin/scanfile.sh > /data/av/info 2>&1
            if [ -e "/data/av/scan/${filename}" ]
            then
                printf "  --> File ok\n"
                mv -f "/data/av/scan/${filename}" "/data/av/ok/${filename}"
                mv -f "/data/av/info" "/data/av/ok/${filename}.log"
                printf "  --> File moved to /data/av/ok/${filename}\n"
            elif [ -e "/data/av/quarantine/${filename}" ]
            then
                printf "  --> File quarantined / nok\n"
                mv -f "/data/av/info" "/data/av/nok/${filename}.log"
                printf "  --> Scan report moved to /data/av/nok/${filename}.log\n"
            fi
>>>>>>> chrishoffman_docker-antivirus/master
        fi
    done
    printf "Done with processing\n"

  sleep 30;
done
