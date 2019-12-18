#!/usr/bin/env bash
##################################################
## hoelzer.martin@gmail.com
#
# Run CWL pipeline on Yoda LSF cluster w/ toil support. 
# activate TOIL env

module load singularity/3.5.0

source activate /homes/mhoelzer/miniconda3/envs/toil

export SINGULARITY_CACHEDIR=/hps/nobackup2/metagenomics/mhoelzer/singularity

### TOIL stuff
export WORK_DIR=/hps/nobackup2/metagenomics/mhoelzer/toil/toil-work4
export OUT_DIR=/hps/nobackup2/metagenomics/mhoelzer/toil/toil-out4
export MEMORY=20G
export NAME_RUN=virify
export CWL=/homes/mhoelzer/git/CWL_viral_pipeline/CWL/WorkFlow/pipeline.cwl
export YML=/homes/mhoelzer/git/CWL_viral_pipeline/CWL/WorkFlow/pipeline.yml
export JOB_TOIL_FOLDER=$WORK_DIR/$NAME_RUN/
export LOG_DIR=${OUT_DIR}/logs_${NAME_RUN}
export TMPDIR=${WORK_DIR}/global-temp-dir_${NAME_RUN}
export OUT_TOOL=${OUT_DIR}/${NAME_RUN}

###  RUN
mkdir -p $JOB_TOIL_FOLDER $LOG_DIR $TMPDIR $OUT_TOOL && \
cd $WORK_DIR && \
rm -rf $JOB_TOIL_FOLDER $OUT_TOOL/* $LOG_DIR/* && \
time toil-cwl-runner \
  --singularity \
  --batchSystem LSF \
  --disableCaching \
  --logDebug \
  --defaultMemory $MEMORY \
  --jobStore $JOB_TOIL_FOLDER \
  --outdir $OUT_TOOL \
  --maxLogFileSize 0 \
  --cleanWorkDir=never \
  --writeLogs $LOG_DIR \
  --retryCount 0  \
  --logFile $LOG_DIR/${NAME_RUN}.log \
$CWL $YML
