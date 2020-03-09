#!/usr/bin/env bash

set -e

# ENV script
# This script defines:
# - CWL file
# - conda env
# - TMPDIR => to prevent using the user TMP FOLDEr
# - Add scripts folder to PATH
# - Add databases to PATH

source /path/to/init.sh

VERSION=$(git rev-parse HEAD)

usage () {
    echo ""
    echo "emg-virify-pipeline version: ${VERSION}"
    echo "" 
    echo "Wrapper script to run the virify workflow."
    echo "-n job_name"
    echo "-j toil job worker path"
    echo "-o Output folder"
    echo "-c Number of cores for the job"
    echo "-m Memory in megabytes"
    echo "-y input YML"
    echo "Example:
            $ virify.sh -n XX -m 1024 -c 12 -j job_folder_path -o /data/results/ -y input.yml
          NOTE:
          - The results folder will be /data/results/{job_name}.
          - The logs will be stored in /data/results/{job_name}/LOGS"
    echo ""
}

while getopts "n:j:o:c:m:" opt; do
  case $opt in
    n)
        NAME_RUN="$OPTARG"
        if [ ! -n "$NAME_RUN" ];
        then
            echo "ERROR (-n): $NAME_RUN cannot be empty." >&2
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
    y)
        YML="$OPTARG"
        if [ ! -z "$YML" ];
        then
            echo "ERROR (-y): $YML cannot be empty." >&2
            usage;
            exit 1
        fi        
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

if ((OPTIND == 1));
then
    usage;
    exit 1
fi


# Prefix the path to make it easier to clean
TMPDIR=${TMPDIR}/${NAME_RUN}

JOB_FOLDER="${JOB_FOLDER}/${NAME_RUN}"
LOG_DIR="${OUT_DIR}/${NAME_RUN}/LOGS"
OUT="${OUT_DIR}/${NAME_RUN}"

# Prepare folders
mkdir -p "$JOB_FOLDER" "$LOG_DIR" "$TMPDIR" "$OUT"

rm -rf "${JOB_FOLDER:?}/"* "${OUT:?}"* "${LOG_DIR:?}/"*

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
  "$YML"