#!/usr/bin/env bash

set -e

source /path/to/requirements/init.sh

# TOIL
export WORK_DIR="<path>"
export OUT_DIR="<path>"
export MEMORY=20G
export NAME_RUN=virify

export CWL=CWL_viral_pipeline/CWL/WorkFlow/pipeline.cwl
export YML=CWL_viral_pipeline/CWL/WorkFlow/pipeline.yml

export JOB_TOIL_FOLDER=$WORK_DIR/$NAME_RUN/
export LOG_DIR=${OUT_DIR}/logs_${NAME_RUN}
export TMPDIR=${WORK_DIR}/global-temp-dir_${NAME_RUN}
export OUT_TOOL=${OUT_DIR}/${NAME_RUN}

# Prepate folders
mkdir -p $JOB_TOIL_FOLDER $LOG_DIR $TMPDIR $OUT_TOOL

cd $WORK_DIR

rm -rf $JOB_TOIL_FOLDER "${OUT_TOOL:?/*}" "${LOG_DIR:?}/*"

# RUN
toil-cwl-runner \
  --no-container \
  --batchSystem LSF \
  --disableCaching \
  --logWarning \
  --defaultMemory $MEMORY \
  --jobStore $JOB_TOIL_FOLDER \
  --outdir $OUT_TOOL \
  --maxLogFileSize 0 \
  --cleanWorkDir=never \
  --writeLogs $LOG_DIR \
  --retryCount 0  \
  --logFile $LOG_DIR/${NAME_RUN}.log \
  $CWL \
  $YML