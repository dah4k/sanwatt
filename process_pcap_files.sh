#!/bin/bash
# Copyright 2025 dah4k
# SPDX-License-Identifier: EPL-2.0

if [ $# -ne 2 ]; then
    echo Usage: $0 PCAP_DIR LOG_DIR
    exit 1
fi

PCAP_DIR=$1
LOG_DIR=$2

QUARANTINE_DIR="/datatmp/QUARANTINE"
[ -d $QUARANTINE_DIR ] || mkdir -p $QUARANTINE_DIR

shopt -s failglob
for x in $PCAP_DIR/*.pcap.gz; do
    echo "[+] Processing $x ..."
    y=${x%.*}
    gunzip --force --keep $x
    suricata -c /etc/suricata/suricata.yaml -l $LOG_DIR -r $y --pcap-file-delete
done

zstd --force --rm $LOG_DIR/{eve.json,fast.log}

clamscan --suppress-ok-results --log=$LOG_DIR/clamav.log --recursive $QUARANTINE_DIR

# clamscan returning 1 when finding infected files...
exit 0
