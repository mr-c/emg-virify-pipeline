#!/usr/bin/env bash

CURRENT=`pwd`
DIR='/Users/mhoelzer/git/CWL_viral_pipeline/CWL/Tools/'

ln -s /Users/mhoelzer/git/What_the_Phage/nextflow-autodownload-databases/virsorter/virsorter-data ${DIR}/VirSorter/

TOOL='LengthFiltering/'
cd ${DIR}/${TOOL}
NAME='cwl_length_filter_docker'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

TOOL='Annotation/'
cd ${DIR}/${TOOL}
NAME='annotation_viral_contigs'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

TOOL='Assign/'
cd ${DIR}/${TOOL}
NAME='assign_taxonomy'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

TOOL='HMMScan/'
cd ${DIR}/${TOOL}
NAME='hmmscan'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

TOOL='Mapping/'
cd ${DIR}/${TOOL}
NAME='mapping_viral_predictions'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

TOOL='Sed/'
cd ${DIR}/${TOOL}
NAME='sed_docker'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

TOOL='ParsingPredictions/'
cd ${DIR}/${TOOL}
NAME='cwl_parse_pred'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

TOOL='Prodigal/'
cd ${DIR}/${TOOL}
#I used nanozoo/prodigal as a template
NAME='prodigal_viral' 
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

TOOL='RatioEvalue/'
cd ${DIR}/${TOOL}
NAME='ratio_evalue'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}

#NOT DONE
TOOL='VirFinder/'
cd ${DIR}/${TOOL}
#I used multifractal/virfinder as a template
NAME='virfinder_viral'
docker build -t ${NAME}:latest .
docker tag ${NAME}:latest mhoelzer/${NAME}:0.1
docker push mhoelzer/${NAME}:0.1
cd ${CURRENT}
