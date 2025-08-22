#!/bin/bash
# Copyright 2025 dah4k
# SPDX-License-Identifier: EPL-2.0

set -e

if [ $# -ne 3 ]; then
    echo Usage: $0 PCAP_DIR LOG_DIR QUARANTINE_DIR
    exit 1
fi

PCAP_DIR=$1
LOG_DIR=$2
QUARANTINE_DIR=$3

shopt -s failglob
for x in $PCAP_DIR/*.pcap.gz; do
    echo "[+] Processing $x ..."
    y=${x%.*}
    gunzip --force --keep $x
    suricata -c /etc/suricata/suricata.yaml -l $LOG_DIR -r $y --pcap-file-delete
done

clamscan --recursive --suppress-ok-results --exclude=.gitignore --log=$LOG_DIR/clamav.log $QUARANTINE_DIR

find $LOG_DIR -type f -name "*.json" -exec zstd --force --rm {} \;
find $LOG_DIR -type f -name "*.log" -exec zstd --force --rm {} \;
