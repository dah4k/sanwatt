#!/bin/sh
# Copyright 2025 dah4k
# SPDX-License-Identifier: EPL-2.0

# Mid-Atlantic Collegiate Cyber Defense Competition (MACCDC)
# https://www.netresec.com/?page=MACCDC

PCAP_FILES="
    maccdc2012_00000.pcap
    maccdc2012_00001.pcap
    maccdc2012_00002.pcap
    maccdc2012_00003.pcap
    maccdc2012_00004.pcap
    maccdc2012_00005_fixed.pcap
    maccdc2012_00006.pcap
    maccdc2012_00007.pcap
    maccdc2012_00008.pcap
    maccdc2012_00009.pcap
    maccdc2012_00010.pcap
    maccdc2012_00011.pcap
    maccdc2012_00012.pcap
    maccdc2012_00013.pcap
    maccdc2012_00014.pcap
    maccdc2012_00015.pcap
    maccdc2012_00016.pcap
"

BASE_URL="https://share.netresec.com/s/7qgDSGNGw2NY8ea"

PCAP_DIR="pcaps"
[ -d $PCAP_DIR ] || mkdir -p $PCAP_DIR

for x in $PCAP_FILES; do
    echo "[+] Fetching $x ..."
    curl -s -L -C - -o "$PCAP_DIR/$x.gz" "$BASE_URL/download?path=%2F&files=$x.gz"
done
