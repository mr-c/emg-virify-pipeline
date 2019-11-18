#!/usr/bin/env bash

##################################################
## hoelzer.martin@gmail.com
#
# Run CWL pipeline on LSF cluster w/ toil support. 

# these command activate our pipeline env. Maybe you can skip them and start only with toil activate
#source /hps/nobackup2/production/metagenomics/pipeline/testing/varsha/test_env.rc
#export PATH=$PATH:/homes/emgpr/.nvm/versions/node/v12.10.0/bin/
#export PATH=/hps/nobackup2/production/metagenomics/pipeline/tools-v5/miniconda2-4.6.14/bin:$PATH
#export PERL5LIB=/hps/nobackup2/production/metagenomics/pipeline/tools-v5/genome-properties/code/modules:$PERL5LIB
#export CONDA_ENV=/hps/nobackup2/production/metagenomics/pipeline/tools-v5/miniconda2-4.6.14/bin/activate

# activate TOIL env
source /hps/nobackup2/production/metagenomics/pipeline/tools-v5/toil-user-env/bin/activate

## SINGULARITY GENERAL
#DIR=/hps/nobackup2/singularity/mhoelzer/build
#export SINGULARITY_CACHEDIR=$DIR/.singularity
#export SINGULARITY_TMPDIR=$DIR/.singularity/tmp
#export SINGULARITY_LOCALCACHEDIR=$DIR/singularity/tmp
#export SINGULARITY_PULLFOLDER=$DIR/.singularity/pull
#export SINGULARITY_BINDPATH=$DIR/.singularity/scratch

## CWL SINGULARITY
#export CWL_SINGULARITY_CACHE=/hps/nobackup2/singularity/mhoelzer/

### TOIL stuff
export WORK_DIR=/homes/mhoelzer/data/toil/work
export OUT_DIR=/homes/mhoelzer/data/toil/out
export MEMORY=20G
export NAME_RUN=virify
export CWL=/homes/mhoelzer/backuped/git/CWL_viral_pipeline/CWL/WorkFlow/pipeline.cwl
export YML=/homes/mhoelzer/backuped/git/CWL_viral_pipeline/CWL/WorkFlow/pipeline.yml
export JOB_TOIL_FOLDER=$WORK_DIR/$NAME_RUN/
export LOG_DIR=${OUT_DIR}/logs_${NAME_RUN}
export TMPDIR=${WORK_DIR}/global-temp-dir_${NAME_RUN}
export OUT_TOOL=${OUT_DIR}/${NAME_RUN}

###  RUN
echo "run first part"
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
  --writeLogs $LOG_DIR \
  --retryCount 0  \
  --logFile $LOG_DIR/${NAME_RUN}.log \
$CWL $YML 
