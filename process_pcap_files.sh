#!/bin/bash
# Copyright 2025 dah4k
# SPDX-License-Identifier: EPL-2.0

if [ $# -ne 3 ]; then
    echo Usage: $0 INPUT_PCAP_DIR OUTPUT_LOG_DIR OUTPUT_INFECTED_DIR
    exit 1
fi

PCAP_DIR=$1
LOG_DIR=$2
INFECTED_DIR=$3

QUARANTINE_DIR="/datatmp/QUARANTINE"
[ -d $QUARANTINE_DIR ] || mkdir -p $QUARANTINE_DIR
INFECTED_UNCART_DIR="/datatmp/INFECTED_UNCART"
[ -d $INFECTED_UNCART_DIR ] || mkdir -p $INFECTED_UNCART_DIR

shopt -s failglob
for x in $PCAP_DIR/*.pcap.gz; do
    echo "[+] Suricata processing $x ..."
    y=${x%.*}
    gunzip --force --keep $x
    suricata -c /etc/suricata/suricata.yaml -l $LOG_DIR -r $y --pcap-file-delete
done

zstd --force --rm $LOG_DIR/{eve.json,fast.log}

echo "[+] ClamAV scanning for infected files ..."
clamscan --suppress-ok-results --log=$LOG_DIR/clamav.log --move=$INFECTED_UNCART_DIR --recursive $QUARANTINE_DIR

# Fix clamav.log permission
chmod 644 $LOG_DIR/clamav.log

# CART any infected files before exporting them out
find $INFECTED_UNCART_DIR -type f -exec cart {} \;
find $INFECTED_UNCART_DIR -type f -name "*.cart" -exec mv {} $INFECTED_DIR \;

exit 0
