cwlVersion: v1.0
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  fasta_file:
    type: File
  hmms_serialized_file:
    type: File
    doc: |
      RatioEvalue hmms_serialized file with the HMM
  hmmscan_database:
    type: Directory
    doc: |
      HMMScan Viral HMM (databases/vpHMM/vpHMM_database).
      NOTE: it needs to be a full path.

outputs:
  prodigal_out:
    outputSource: prodigal/output_fasta
    type: File
  hmmscan_out:
    outputSource: hmmscan/output_table
    type: File
  modification_out:
    outputSource: hmm_postprocessing/modified_file
    type: File
  ratio_evalue_table:
    outputSource: ratio_evalue/informative_table
    type: File
  annotation_table:
    outputSource: annotation/annotation_table
    type: File
  assign_results:
    outputSource: assign/assign_table
    type: File

steps:
  prodigal:
    label: "Protein-coding gene prediction for prokaryotic genomes"
    in:
      input_fasta: fasta_file
    out:
      - output_fasta
    run: ../Tools/Prodigal/prodigal.cwl

  hmmscan:
    in:
      seqfile: prodigal/output_fasta
      database: hmmscan_database
    out:
      - output_table
    run: ../Tools/HMMScan/hmmscan.cwl

  hmm_postprocessing:
    in:
      input_table: hmmscan/output_table
    out:
      - modified_file
    run: ../Tools/Modification/processing_hmm_result.cwl

  ratio_evalue:
    in:
      input_table: hmm_postprocessing/modified_file
      hmms_serialized: hmms_serialized_file
    out:
      - informative_table
    run: ../Tools/RatioEvalue/ratio_evalue.cwl

  annotation:
    in:
      input_fasta: prodigal/output_fasta
      input_table: ratio_evalue/informative_table
      input_fna: fasta_file
    out:
      - annotation_table
    run: ../Tools/Annotation/viral_annotation.cwl

  assign:
    in:
      input_table: annotation/annotation_table
    out:
      - assign_table
    run: ../Tools/Assign/assign.cwl