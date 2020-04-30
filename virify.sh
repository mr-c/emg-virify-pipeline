#!/usr/bin/env bash

set -e

# ENV script
# This script defines:
# - CWL file
# - conda env
# - TMPDIR => to prevent using the user TMP FOLDEr
# - Add scripts folder to PATH
# - export databases variables:
#   - VIRSORTER_DATA 
#   - HMMS_SERIALIZED_FILE
#   - HMMSCAN_DATABASE_DIRECTORY
#   - NCBI_TAX_DB_FILE
#   - IMGVR_BLAST_DB
# - Add PERL5LIB point to conda site_perl path 
# - exports $CWL with the full path to the pipeline.cwl

source /nfs/production/interpro/metagenomics/virify_pipeline/init.sh  # /path/to/init.sh

usage () {
    echo ""
    echo "Wrapper script to run the virify workflow using toil-cwl-runner."
    echo "-n job_name"
    echo "-j toil job worker path"
    echo "-o Output folder"
    echo "-c Number of cores for the job"
    echo "-m Memory in megabytes"
    echo "-i intput fasta contigs"
    echo "-v virome mode for virsorter"
    echo "Example:
            $ virify.sh -n XX -m 1024 -c 12 -j job_folder_path -o /data/results/ -i input.fasta
          NOTE:
          - The results folder will be /data/results/{job_name}.
          - The logs will be stored in /data/results/{job_name}/LOGS"
    echo ""
}

VIROME=""

while getopts ":n:j:o:c:m:i:v" opt; do
  case $opt in
    n)
        NAME_RUN="$OPTARG"
        if [ ! -n "$NAME_RUN" ];
        then
            echo "ERROR -n cannot be empty." >&2
            usage;
            exit 1
        fi
        ;;
    j)
        JOB_FOLDER="$OPTARG"
        ;;
    o)
        OUT_DIR="$OPTARG"
        mkdir -p "$OUT_DIR"
        ;;
    c)
        CORES="$OPTARG"
        if ! [[ "$CORES" =~ ^[0-9]+$ ]]
        then
            echo "ERROR (-c): $CORES is not a number." >&2
            usage;
            exit 1
        fi
        ;;
    m)
        MEMORY="$OPTARG"
        if ! [[ "$MEMORY" =~ ^[0-9]+$ ]]
        then
            echo "ERROR (-m): $MEMORY is not a number." >&2
            usage;
            exit 1
        fi
        ;;
    i)
        INPUT_FASTA="$OPTARG"
        if [ ! -n "$INPUT_FASTA" ];
        then
            echo "ERROR -i cannot be empty." >&2
            usage;
            exit 1
        fi        
        ;;
    v)
        VIROME="--virome"
        ;;        
    :)
        usage;
        exit 1
        ;;
    \?)
        echo "Invalid option -$OPTARG" >&2
        usage;
    ;;
  esac
done

shift $((OPTIND -1))


# Prefix the path to make it easier to clean
TMPDIR=${TMPDIR}/${NAME_RUN}

JOB_FOLDER="${JOB_FOLDER}/${NAME_RUN}"
LOG_DIR="${OUT_DIR}/${NAME_RUN}/LOGS"
OUT="${OUT_DIR}/${NAME_RUN}"

# Prepare folders
rm -rf "${JOB_FOLDER}"
rm -rf "${OUT}"
rm -rf "${LOG_DIR}"

mkdir -p "$LOG_DIR"
mkdir -p "$TMPDIR"
mkdir -p "$OUT"

toil-cwl-runner \
  --no-container \
  --batchSystem LSF \
  --disableCaching \
  --logDebug \
  --maxLogFileSize 0 \
  --cleanWorkDir=never \
  --defaultCores "$CORES" \
  --defaultMemory "$MEMORY" \
  --jobStore "$JOB_FOLDER" \
  --outdir "$OUT" \
  --writeLogs "$LOG_DIR" \
  --retryCount 0  \
  --logFile "$LOG_DIR/${NAME_RUN}.log" \
  "$CWL" \
  --virsorter_data_dir "$VIRSORTER_DATA" \
  --hmms_serialized_file "$HMMS_SERIALIZED_FILE" \
  --hmmscan_database_directory "$HMMSCAN_DATABASE_DIRECTORY" \
  --ncbi_tax_db_file "$NCBI_TAX_DB_FILE" \
  --input_fasta_file "$INPUT_FASTA"  \
  --img_blast_database_dir "$IMGVR_BLAST_DB" \
  ${VIROME}