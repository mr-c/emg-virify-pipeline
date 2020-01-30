#!/bin/bash

echo 'Downloading VirSorter DB and HMMER db from the Metagenomics FTP server'
echo '----------------------------------------------------------------------'

if [ ! -d "$1/virsorter-data" ];
then
    mkdir -p "$1/virsorter-data" && \
    wget \
        ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/VirSorter_data_viral/virsorter-data-v2.tar.gz -O virsorter-data-v2.tar.gz \
        --progress=bar:force:noscroll && \
    tar --extract --gzip --verbose --file=virsorter-data-v2.tar.gz --directory="$1" && \
    rm virsorter-data-v2.tar.gz
else
  echo '# virsorter-data present in cache'
fi

if [ ! -d "$1/vpHMM" ];
then
  mkdir -p "$1/vpHMM" && \
  wget \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/vpHMM_database.tar.gz -O vpHMM_database.tar.gz \
    --progress=bar:force:noscroll && \
  tar --extract --gzip --verbose --file=vpHMM_database.tar.gz --directory="$1/vpHMM" --strip-components=1 && \
  rm vpHMM_database.tar.gz
else
  echo '# vpHMM present in cache'
fi

if [ ! -f "$1/ete3_ncbi_tax.sqlite" ];
then
  wget \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/viral-pipeline/ete3_ncbi_tax.sqlite.gz -O ete3_ncbi_tax.sqlite.gz \
    --progress=bar:force:noscroll && \
  gunzip -c ete3_ncbi_taxX.sqlite.gz > "$1/ete3_ncbi_tax.sqlite"
else
  echo '# ete3_ncbi_tax present in cache'
fi

if [ ! -f "$1/vphmm_2020-01-29.pickle" ];
then
  wget \
    ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/viral-pipeline/vphmm_2020-01-29.pickle -O "$1/vphmm_2020-01-29.pickle" \
    --progress=bar:force:noscroll
else
  echo '# vphmm_2020-01-29.pickle present in cache'
fi