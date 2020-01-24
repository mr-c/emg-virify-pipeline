#!/usr/bin/env bash
##################################################
### CONDA env and other ENV variables
source /nfs/production/interpro/metagenomics/viral_pipeline/init.sh
### TOIL stuff
export WORK_DIR=/hps/nobackup2/production/metagenomics/kate/viral/work-dir
export OUT_DIR=/hps/nobackup2/production/metagenomics/kate/viral/out-dir

export MEMORY=10G
export NAME_RUN=virify
export CWL=/hps/nobackup2/production/metagenomics/kate/viral/CWL_viral_pipeline/CWL/WorkFlow/pipeline.cwl
export YML=/homes/mhoelzer/toil_run/PRJNA530103_raw_assembly.yml

export JOB_TOIL_FOLDER=$WORK_DIR/$NAME_RUN/
export LOG_DIR=${OUT_DIR}/logs_${NAME_RUN}
export TMPDIR=${WORK_DIR}/tmp_${NAME_RUN}
export OUT_TOOL=${OUT_DIR}/${NAME_RUN}

mkdir -p $JOB_TOIL_FOLDER $LOG_DIR $TMPDIR $OUT_TOOL && \
cd $WORK_DIR && \
rm -rf $JOB_TOIL_FOLDER $OUT_TOOL/* $LOG_DIR/* && \
time toil-cwl-runner \
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
$CWL $YML