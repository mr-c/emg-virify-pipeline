# CWL viral pipeline

[![Build Status](https://api.travis-ci.org/EBI-Metagenomics/emg-viral-pipeline.svg?branch=dev)](https://travis-ci.org/EBI-Metagenomics/emg-viral-pipeline)

CWL implementation of the MGnify viral pipeline.

## Setup

Install CONDA and create an env using the `conda_env.yml` file:

**Rename the path in requirements/conda_env.yml to the desired env path**

```bash
$ conda env create -f requirements/conda_env.yml
```

The `init.sh` file is meant to set some env variables needed for the execution, this script is called from `run_toil.sh`.

### Data pre-requirements

#### Ratio Evalue 

Needs an object that is generated by running [generate_vphmm_object.py](CWL/Tools/RatioEvalue/hmmer_generation/generate_vphmm_object.py). The output of this file is an input of the pipeline.

The current version of the HMMs is `databases/vphmm_2020-01-29.pickle`. This version will be used by default.

#### VirSorter

Download the virsorter db and create a symlink in databases:

```bash
$ ./travis/download_virsoter_db.sh path/to/
$ ln -s path/to/virsorter-data databases/virsorter-data
```

It's possible to specify the path but by default `databases/virsorter-data` will be used.

## Running full pipeline from CLI

The pipeline users [toil](https://github.com/DataBiosphere/toil) as the CWL execution engine.

In order to run it use the helper script (provided you adjusted the paths on it).

```bash
$ ./run_toil.sh
```

## Structure of pipeline

**Input**: assembly file NAME.fasta

**1. Filtering contigs** <br>
Filter contigs by length threshold in kb (default: 5kb). <br>
     ***Input***: NAME.fasta <br>
     ***Output***: NAME_filt500bp.fasta 
   
**2.1. VirSorter** <br>
Mining viral signal from microbial genomic data. Tool generates folder *Predicted_viral_sequences* (relevant are VIRSorter_cat-[123].fasta and VIRSorter_prophages_cat-[45].fasta). <br>
     ***Input***: NAME_filt500bp.fasta <br>
     ***Output***: Predicted_viral_sequences
     
**2.2. VirFinder** <br>
R package for identifying viral sequences from metagenomic data using sequence signatures. <br>
     ***Input***: NAME_filt500bp.fasta <br>
     ***Output***: VirFinder_output.tsv
     
**3. Parsing virus files**   
According of results on previous steps script generates high_confidence, low_confidence and Prophages files. Some of output files may be missing. <br>
     ***Input***: <br>
                  - NAME_filt500bp.fasta <br>
                  - VirFinder_output.tsv <br>
                  - Predicted_viral_sequences <br>
     ***Output***: <br>
                  - high_confidence.fna <br>
                  - low_confidence.fna <br>
                  - Prophages.fna
                  
**4. Prodigal** <br>
Tool predicts proteins for each input fasta-file. <br>
     ***Input***: output files of step #3  <br>
                  - high_confidence.fna <br>
                  - low_confidence.fna <br>
                  - Prophages.fna <br>
     ***Output***: <br>
                  - high_confidence_prodigal.faa <br>
                  - low_confidence_prodigal.faa <br>
                  - Prophages_prodigal.faa
    
**5. HMMSCAN** <br>
HMMSCAN is used to search protein sequences against collections of protein profiles. <br>
    ***Input***: output files of step #4  <br>
                  - high_confidence_prodigal.faa <br>
                  - low_confidence_prodigal.faa <br>
                  - Prophages_prodigal.faa <br>
    ***Output***:  <br>
                  - high_confidence_prodigal_hmmscan.tbl <br>
                  - low_confidence_prodigal_hmmscan.tbl <br>
                  - Prophages_prodigal_hmmscan.tbl <br>
                  
**6. Table(s) processing** <br>
Scripts add titles to columns and separate columns with tabs. <br>
    ***Input***: <br>
                  - high_confidence_prodigal_hmmscan.tbl <br>
                  - low_confidence_prodigal_hmmscan.tbl <br>
                  - Prophages_prodigal_hmmscan.tbl <br>
    ***Output***: <br>
                  - high_confidence_prodigal_hmmscan_modified.faa <br>
                  - low_confidence_prodigal_hmmscan_modified.faa <br>
                  - Prophages_prodigal_hmmscan_modified.faa <br>
        
**7. Ratio evalue table** <br>
Generates tabular file (File_informative_ViPhOG.tsv) listing results per protein, which include the ratio of the aligned target profile and the abs value of the total Evalue. <br>
    ***Input***: <br>
                  - high_confidence_prodigal_hmmscan_modified.faa <br>
                  - low_confidence_prodigal_hmmscan_modified.faa <br>
                  - Prophages_prodigal_hmmscan_modified.faa <br>
    ***Output***: <br>
                  - high_confidence_prodigal_hmmscan_modified_informative.tsv <br>
                  - low_confidence_prodigal_hmmscan_modified_informative.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative.tsv <br>


**8. Annotation** <br>
Script generates tabular output for each viral prediction file which summarizes the ViPhOG annotations for all the corresponding predicted proteins. <br>
    ***Input***: <br>
                  - high_confidence.fna <br>
                  - high_confidence_prodigal_hmmscan_modified_informative.tsv <br>
                  - high_confidence.fna <br>
                  - low_confidence.fna <br>
                  - low_confidence_prodigal_hmmscan_modified_informative.tsv <br>
                  - low_confidence.fna <br>
                  - Prophages.fna <br>
                  - Prophages_prodigal_hmmscan_modified_informative.tsv <br>
                  - Prophages.fna <br>
   ***Output***: <br>           
                  - high_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - low_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                 
**9.1. Assign taxonomy** <br>
Script generates tabular file with taxonomic assignment of viral contigs based on ViPhOG annotations.<br>
   ***Input***: <br>           
                  - high_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - low_confidence_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative_prot_ann_table.tsv <br>
   ***Output***: <br>
                  - high_confidence_prodigal_hmmscan_modified_informative_prot_ann_table_tax_assign.tsv <br>
                  - low_confidence_prodigal_hmmscan_modified_informative_prot_ann_table_tax_assign.tsv <br>
                  - Prophages_prodigal_hmmscan_modified_informative_prot_ann_table_tax_assign.tsv <br>
  
```
          Assembly
             |
          Length filter
             |        \
             |         \
          VirFinder  VirSorter
             |         /
             |        /
          Parsing virus files
                   |
                   |
                Prodigal             ----
                   |    |               |    
                   |    |               S
                   |    |               u
               HMMscan   \              b
                   |      \             W
            Modification   |            o
                   |      /             r
                   |     /              k
                  Annotation            F
                     |                  l
                     |                  o
                  Assign                w
                     |                  |
                     |                  |
                   Krona             ---|
```

# Tests

CWL tests are executed with (cwltest)[https://github.com/common-workflow-language/cwltest].

Please refer to `run_tests.sh`.