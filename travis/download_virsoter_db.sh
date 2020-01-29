#!/bin/bash

if [ ! -d "$1" ];
then
    mkdir -p "$1"
    wget \
        ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/VirSorter_data_viral/virsorter-data-v2.tar.gz -qO - | \
        tar --extract --gzip --verbose --file=/dev/stdin --directory="$1"
fi