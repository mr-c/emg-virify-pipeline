#!/bin/bash

echo 'Downloading VirSorter DB and HMMER db from the Metagenomics FTP server'

if [ ! -d "$1/virsorter-data" ];
then
    mkdir -p "$1/virsorter-data"
    wget \
        ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/VirSorter_data_viral/virsorter-data-v2.tar.gz -qO - | \
        tar --extract --gzip --verbose --file=/dev/stdin --directory="$1"
fi

if [ ! -d "$1/vpHMM" ];
then
  mkdir -p "$1/vpHMM"
  wget \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/vpHMM_database.tar.gz -qO - | \
    tar --extract --gzip --verbose --file=/dev/stdin --directory="$1" --strip-components=1
fi