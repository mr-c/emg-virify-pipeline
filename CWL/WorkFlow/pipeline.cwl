cwlVersion: v1.0
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}  
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  input_fasta_file:  # input assembly
    type: File
  virsorter_data_dir:
    type: Directory
    default:
      ../../databases/virsorter-data
  hmms_serialized_file:
    type: File
    default:
      ../../databases/vphmm_2020-01-29.pickle
    doc:
      See Tools/RatioEvalue/ratio_evalue.cwl > hmms_serialized parameter
      Current version /databases/vphmm_2020-01-29.pickle.
  hmmscan_database_directory:
    type: Directory
    default:
      ../../databases/vpHMM
    doc: |
      HMMScan Viral HMM (databases/vpHMM/vpHMM_database).
      NOTE: it needs to be a full path.
  ncbi_tax_db_file:
    type: File
    default:
      ../../databases/ete3_ncbi_tax.sqlite
    doc: |
      ete3 NCBITaxa db https://github.com/etetoolkit/ete/blob/master/ete3/ncbi_taxonomy/ncbiquery.py
      http://etetoolkit.org/docs/latest/tutorial/tutorial_ncbitaxonomy.html
      This file was manually built and placed in the corresponding path (on databases)

outputs:
  output_length_filtering:
    outputSource: length_filter/filtered_contigs_fasta
    type: File
  output_virfinder:
    outputSource: virfinder/output
    type: File
  output_virsorter:
    outputSource: virsorter/predicted_viral_seq_dir
    type: Directory
  output_parse:
    outputSource: parse_pred_contigs/output_fastas
    type:
      type: array
      items: File
  output_parse_stdout:
    outputSource: parse_pred_contigs/stdout
    type: File
  output_parse_stderr:
    outputSource: parse_pred_contigs/stderr
    type: File
  output_prodigal:
    outputSource: subworkflow_for_each_fasta/prodigal_out
    type:
      type: array
      items: File
  output_final_assign:
    outputSource: subworkflow_for_each_fasta/assign_results
    type:
      type: array
      items: File

steps:
  length_filter:
    in:
      fasta_file: input_fasta_file
    out:
      - filtered_contigs_fasta
    run: ../Tools/LengthFiltering/length_filtering.cwl

  virfinder:
    in:
      fasta_file: length_filter/filtered_contigs_fasta
    out:
      - output
    run: ../Tools/VirFinder/virfinder.cwl
    label: "VirFinder: R package for identifying viral sequences from metagenomic data using sequence signatures"

  virsorter:
    in:
      fasta_file: length_filter/filtered_contigs_fasta
      data_dir: virsorter_data_dir
    out:
      - predicted_viral_seq_dir
    run: ../Tools/VirSorter/virsorter.cwl
    label: "VirSorter: mining viral signal from microbial genomic data"

  parse_pred_contigs:
    in:
      assembly: length_filter/filtered_contigs_fasta
      virfinder_tsv: virfinder/output
      virsorter_dir: virsorter/predicted_viral_seq_dir
    out:
      - output_fastas
      - stdout
      - stderr
    run: ../Tools/ParsingPredictions/parse_viral_pred.cwl

  subworkflow_for_each_fasta:
    in:
      fasta_file: parse_pred_contigs/output_fastas  # array
      # DBs
      hmms_serialized_file: hmms_serialized_file
      hmmscan_database: hmmscan_database_directory
      ncbi_tax_db_file: ncbi_tax_db_file
    out:
      - prodigal_out
      - hmmscan_out
      - modification_out
      - ratio_evalue_table
      - annotation_table
      - assign_results

    scatter: fasta_file
    run: subworkflow_viral_processing.cwl

doc: |
  scheme:
          Assembly
             |
          Length filter
             |        \
             |         \
          VirFinder     VirSorter
             |         /
             |        /
          Parsing virus files
                   |
                   |
                Prodigal             -- S
                   |    \               u
               HMMscan   \              b
                   |      \             W
            Modification   |            o
                   |      /             r
                   |     /              k
                  Annotation            F
                     |                  l
                     |                  o
                   Assign            -- w