# Copyright 2025 dah4k
# SPDX-License-Identifier: EPL-2.0

FROM opensuse/tumbleweed:latest

RUN zypper --quiet --non-interactive refresh \
 && zypper --quiet --non-interactive install --no-recommends \
        curl \
        fd \
        suricata \
        zstd \
 && zypper --quiet --non-interactive clean

WORKDIR /pcaps

COPY download_pcap_files.sh .

RUN ./download_pcap_files.sh

WORKDIR /results

RUN suricata -c /etc/suricata/suricata.yaml -r /pcaps \
 && fd --extension log --extension json --exec zstd --rm

WORKDIR /pcaps

RUN fd --extension pcap --exec zstd --rm
