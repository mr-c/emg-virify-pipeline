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
  # == Databases == #
  virsorter_data_dir:
    type: Directory
    default:
      class: Directory
      path: ../../databases/virsorter-data
  hmms_serialized_file:
    type: File
    default:
      class: File
      path: ../../databases/vphmm_2020-01-29.pickle
    doc: |
      "See Tools/RatioEvalue/ratio_evalue.cwl > hmms_serialized parameter
      Current version /databases/vphmm_2020-01-29.pickle."
  hmmscan_database_directory:
    type: Directory
    default:
      class: Directory
      path: ../../databases/vpHMM
    doc: |
      "HMMScan Viral HMM (databases/vpHMM/vpHMM_database).
      NOTE: it needs to be a full path."
  ncbi_tax_db_file:
    type: File
    default:
      class: File
      path: ../../databases/ete3_ncbi_tax.sqlite
    doc: |
      "ete3 NCBITaxa db https://github.com/etetoolkit/ete/blob/master/ete3/ncbi_taxonomy/ncbiquery.py
      http://etetoolkit.org/docs/latest/tutorial/tutorial_ncbitaxonomy.html
      This file was manually built and placed in the corresponding path (on databases)"

steps:
  length_filter:
    label: "len filter the contigs files"
    run: ../Tools/LengthFiltering/length_filtering.cwl
    in:
      fasta_file: input_fasta_file
    out:
      - filtered_contigs_fasta

  virfinder:
    label: "VirFinder: R package for identifying viral sequences from metagenomic data using sequence signatures"
    run: ../Tools/VirFinder/virfinder.cwl
    in:
      fasta_file: length_filter/filtered_contigs_fasta
    out:
      - virfinder_output

  virsorter:
    label: "VirSorter: mining viral signal from microbial genomic data"
    run: ../Tools/VirSorter/virsorter.cwl
    in:
      fasta_file: length_filter/filtered_contigs_fasta
      data_dir: virsorter_data_dir
    out:
      - predicted_viral_seq_dir

  parse_pred_contigs:
    run: ../Tools/ParsingPredictions/parse_viral_pred.cwl
    in:
      assembly: length_filter/filtered_contigs_fasta
      virfinder_tsv: virfinder/virfinder_output
      virsorter_dir: virsorter/predicted_viral_seq_dir
    out:
      - high_confidence_contigs
      - low_confidence_contigs
      - prophages_contigs

  prodigal:
    label: "Protein-coding gene prediction for prokaryotic genomes"
    run: ../Tools/Prodigal/prodigal_swf.cwl
    in:
      high_confidence_contigs: parse_pred_contigs/high_confidence_contigs
      low_confidence_contigs: parse_pred_contigs/low_confidence_contigs
      prophages_contigs: parse_pred_contigs/prophages_contigs
    out:
      - high_confidence_contigs_genes
      - low_confidence_contigs_genes
      - prophages_contigs_genes

  hmmscan:
    run: ../Tools/HMMScan/hmmscan_swf.cwl
    in:
      aa_fasta_files:
        source: 
          - prodigal/high_confidence_contigs_genes
          - prodigal/low_confidence_contigs_genes
          - prodigal/prophages_contigs_genes
        linkMerge: merge_flattened
      database: hmmscan_database_directory
    out:
      # single concatenated table
      - output_table

  hmm_postprocessing:
    run: ../Tools/Modification/processing_hmm_result.cwl
    in:
      input_table: hmmscan/output_table
    out:
      - modified_file

  ratio_evalue:
    run: ../Tools/RatioEvalue/ratio_evalue.cwl
    in:
      input_table: hmm_postprocessing/modified_file
      hmms_serialized: hmms_serialized_file
    out:
      - informative_table

  annotation:
    run: ../Tools/Annotation/viral_annotation_swf.cwl
    in:
      input_fastas:
        source:
          - prodigal/high_confidence_contigs_genes
          - prodigal/low_confidence_contigs_genes
          - prodigal/prophages_contigs_genes
        linkMerge: merge_flattened
      # TODO: check input_table: ratio_evalue/informative_table
      hmmer_table: ratio_evalue/informative_table
    out:
      - annotation_tables

  assign:
    run: ../Tools/Assign/assign_swf.cwl
    in:
      input_tables: annotation/annotation_tables
      ncbi_tax_db: ncbi_tax_db_file
    out:
      - assign_tables

  krona:
    run:  ../Tools/Krona/krona_swf.cwl
    in:
      assign_tables: assign/assign_tables
    out:
      - krona_html

outputs:
  output_length_filtering:
    outputSource: length_filter/filtered_contigs_fasta
    type: File
  output_virfinder:
    outputSource: virfinder/virfinder_output
    type: File
  output_virsorter:
    outputSource: virsorter/predicted_viral_seq_dir
    type: Directory
  output_parse_high_confidence_contigs:
    outputSource: parse_pred_contigs/high_confidence_contigs
    type: File
  output_parse_low_confidence_contigs:
    outputSource: parse_pred_contigs/low_confidence_contigs
    type: File
  output_parse_prophages_contigs:
    outputSource: parse_pred_contigs/prophages_contigs
    type: File
  output_prodigal_high_confidence:
    outputSource: prodigal/high_confidence_contigs_genes
    type: File
  output_prodigal_low_confidence:
    outputSource: prodigal/low_confidence_contigs_genes
    type: File
  output_prodigal_prophages:
    outputSource: prodigal/prophages_contigs_genes
    type: File
  output_final_assign:
    outputSource: assign/assign_tables
    type:
      type: array
      items: File
  output_krona_htmls:
    outputSource: krona/krona_html
    type:
      type: array
      items: File