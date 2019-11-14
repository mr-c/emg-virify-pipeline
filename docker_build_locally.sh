#!/usr/bin/env bash

CURRENT=`pwd`
DIR='/Users/mhoelzer/git/CWL_viral_pipeline/CWL/Tools/'

TOOL='LengthFiltering/'
cd ${DIR}/${TOOL}
docker build -t cwl_length_filter_docker:latest .
cd ${CURRENT}

TOOL='Annotation/'
cd ${DIR}/${TOOL}
docker build -t annotation_viral_contigs:latest .
cd ${CURRENT}

TOOL='Assign/'
cd ${DIR}/${TOOL}
docker build -t assign_taxonomy:latest .
cd ${CURRENT}

TOOL='HMMScan/'
cd ${DIR}/${TOOL}
docker build -t hmmscan:latest .
cd ${CURRENT}

TOOL='Mapping/'
cd ${DIR}/${TOOL}
docker build -t mapping_viral_predictions:latest .
cd ${CURRENT}

TOOL='Sed/'
cd ${DIR}/${TOOL}
docker build -t sed_docker:latest .
cd ${CURRENT}

TOOL='ParsingPredictions/'
cd ${DIR}/${TOOL}
docker build -t cwl_parse_pred:latest .
cd ${CURRENT}

TOOL='Prodigal/'
cd ${DIR}/${TOOL}
#I used nanozoo/prodial as a template 
docker build -t prodigal_viral:latest .
cd ${CURRENT}

TOOL='RatioEvalue/'
cd ${DIR}/${TOOL}
docker build -t ratio_evalue:latest .
cd ${CURRENT}

#NOT DONE
TOOL='VirFinder/'
cd ${DIR}/${TOOL}
#I used multifractal/virfinder as a template
docker build -t virfinder_viral:latest .
#docker pull multifractal/virfinder:0.1
#docker tag multifractal/virfinder:0.1 virfinder_viral:latest
cd ${CURRENT}
