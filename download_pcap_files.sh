#!/bin/sh
# Copyright 2025 dah4k
# SPDX-License-Identifier: EPL-2.0

if [ $# -ne 1 ]; then
    echo Usage: $0 DOWNLOAD_PCAP_DIR
    exit 1
fi

PCAP_DIR=$1

# Mid-Atlantic Collegiate Cyber Defense Competition (MACCDC)
# https://www.netresec.com/?page=MACCDC

PCAP_FILES="
    maccdc2012_00000.pcap.gz
    maccdc2012_00001.pcap.gz
    maccdc2012_00002.pcap.gz
    maccdc2012_00003.pcap.gz
    maccdc2012_00004.pcap.gz
    maccdc2012_00005_fixed.pcap.gz
    maccdc2012_00006.pcap.gz
    maccdc2012_00007.pcap.gz
    maccdc2012_00008.pcap.gz
    maccdc2012_00009.pcap.gz
    maccdc2012_00010.pcap.gz
    maccdc2012_00011.pcap.gz
    maccdc2012_00012.pcap.gz
    maccdc2012_00013.pcap.gz
    maccdc2012_00014.pcap.gz
    maccdc2012_00015.pcap.gz
    maccdc2012_00016.pcap.gz
"

BASE_URL="https://share.netresec.com/s/7qgDSGNGw2NY8ea"

[ -d $PCAP_DIR ] || mkdir -p $PCAP_DIR

for x in $PCAP_FILES; do
    echo "[+] Fetching $x ..."
    curl -s -L -C - -o "$PCAP_DIR/$x" "$BASE_URL/download?path=%2F&files=$x"
done
