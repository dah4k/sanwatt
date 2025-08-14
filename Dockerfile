# Copyright 2025 dah4k
# SPDX-License-Identifier: EPL-2.0

FROM opensuse/tumbleweed:latest

RUN zypper --quiet --non-interactive refresh \
 && zypper --quiet --non-interactive install --no-recommends \
        curl \
        jq \
        ripgrep \
        suricata \
        vim \
        vim-data \
        zstd \
 && zypper --quiet --non-interactive clean

WORKDIR /results

COPY config/suricata.yaml /etc/suricata/suricata.yaml

COPY download_and_process_pcap_files.sh .

RUN ./download_and_process_pcap_files.sh && zstd *.json *.log --rm

