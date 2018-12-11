#!/bin/bash

set -u
[ -n "${DEBUG:-}" ] && set -x

now=`date +'%Y-%m-%d %T'`
printf "[${now}]\n"

# scan with ClamAV first (faster)
clamscan --recursive --infected --enable-stats "$@"

# custom maldet config scans and reports only
maldet --report -a "$@"
