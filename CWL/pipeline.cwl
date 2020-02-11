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
    doc: |
      VirSorter supporting database files.
  hmms_serialized_file:
    type: File
    doc: |
      See Tools/RatioEvalue/ratio_evalue.cwl > hmms_serialized parameter
      Current version /databases/vphmm_2020-01-29.pickle.
  hmmscan_database_directory:
    type: Directory
    doc: |
      HMMScan Viral HMM (databases/vpHMM/vpHMM_database).
      NOTE: it needs to be a full path.
  ncbi_tax_db_file:
    type: File
    doc: |
      ete3 NCBITaxa db https://github.com/etetoolkit/ete/blob/master/ete3/ncbi_taxonomy/ncbiquery.py
      http://etetoolkit.org/docs/latest/tutorial/tutorial_ncbitaxonomy.html
      This file was manually built and placed in the corresponding path (on databases)

steps:
  length_filter:
    label: Filter contigs
    run: ./Tools/LengthFiltering/length_filtering.cwl
    in:
      fasta_file: input_fasta_file
    out:
      - filtered_contigs_fasta

  virfinder:
    label: VirFinder
    run: ./Tools/VirFinder/virfinder.cwl
    in:
      fasta_file: length_filter/filtered_contigs_fasta
    out:
      - virfinder_output

  virsorter:
    label: VirSorter
    run: ./Tools/VirSorter/virsorter.cwl
    in:
      fasta_file: length_filter/filtered_contigs_fasta
      data_dir: virsorter_data_dir
    out:
      - predicted_viral_seq_dir

  parse_pred_contigs:
    label: Combine
    run: ./Tools/ParsingPredictions/parse_viral_pred.cwl
    in:
      assembly: length_filter/filtered_contigs_fasta
      virfinder_tsv: virfinder/virfinder_output
      virsorter_dir: virsorter/predicted_viral_seq_dir
    out:
      - high_confidence_contigs
      - low_confidence_contigs
      - prophages_contigs

  prodigal:
    label: Prodigal
    run: ./Tools/Prodigal/prodigal_swf.cwl
    in:
      high_confidence_contigs: parse_pred_contigs/high_confidence_contigs
      low_confidence_contigs: parse_pred_contigs/low_confidence_contigs
      prophages_contigs: parse_pred_contigs/prophages_contigs
    out:
      - high_confidence_contigs_genes
      - low_confidence_contigs_genes
      - prophages_contigs_genes

  hmmscan:
    label: hmmscan
    run: ./Tools/HMMScan/hmmscan_swf.cwl
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

  ratio_evalue:
    label: ratio evalue ViPhOG
    run: ./Tools/RatioEvalue/ratio_evalue.cwl
    in:
      input_table: hmmscan/output_table
      hmms_serialized: hmms_serialized_file
    out:
      - informative_table

  annotation:
    label: ViPhOG annotations
    run: ./Tools/Annotation/viral_annotation_swf.cwl
    in:
      input_fastas:
        source:
          - prodigal/high_confidence_contigs_genes
          - prodigal/low_confidence_contigs_genes
          - prodigal/prophages_contigs_genes
        linkMerge: merge_flattened
      hmmer_table: ratio_evalue/informative_table
    out:
      - annotation_tables

  assign:
    label: Taxonomic assign
    run: ./Tools/Assign/assign_swf.cwl
    in:
      input_tables: annotation/annotation_tables
      ncbi_tax_db: ncbi_tax_db_file
    out:
      - assign_tables

  krona:
    label: krona plots
    run:  ./Tools/Krona/krona_swf.cwl
    in:
      assign_tables: assign/assign_tables
    out:
      - krona_htmls
      - krona_all_html

outputs:
  filtered_contigs:
    outputSource: length_filter/filtered_contigs_fasta
    type: File
  virfinder_output:
    outputSource: virfinder/virfinder_output
    type: File
  virsorter_output:
    outputSource: virsorter/predicted_viral_seq_dir
    type: Directory
  high_confidence_contigs:
    outputSource: parse_pred_contigs/high_confidence_contigs
    type: File
  low_confidence_contigs:
    outputSource: parse_pred_contigs/low_confidence_contigs
    type: File
  parse_prophages_contigs:
    outputSource: parse_pred_contigs/prophages_contigs
    type: File
  high_confidence_faa:
    outputSource: prodigal/high_confidence_contigs_genes
    type: File
  low_confidence_faa:
    outputSource: prodigal/low_confidence_contigs_genes
    type: File
  prophages_faa:
    outputSource: prodigal/prophages_contigs_genes
    type: File
  taxonomy_assignations:
    outputSource: assign/assign_tables
    type:
      type: array
      items: File
  krona_plots:
    outputSource: krona/krona_htmls
    type:
      type: array
      items: File
  krona_plot_all:
    outputSource: krona/krona_all_html
    type: File