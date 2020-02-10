cwlVersion: v1.0
class: Workflow

label: Hmmscan

doc: |
  Run hmmscan over an array of files (supports empty or non existent files).
  The output will be the concatenation of the output tables.

requirements:
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  aa_fasta_files:
    type:
      type: array
      items: File!
    doc: FASTA Protein files
  database:
    type: Directory

steps:
  hmmscan:
    run: hmmscan.cwl
    scatter: aa_fasta_file
    label: Run hmmscan
    in:
      aa_fasta_file: aa_fasta_files
      database: database
    out:
      - output_table
  concatenate:
    run: ../Utils/concatenate.cwl
    label: CAT the tables
    in:
      files: hmmscan/output_table
      name:
        valueFrom: "tmp_table.tsv"
    out:
      - result
  post_processing:
    run: hmmscan_postprocessing.cwl
    label: Format the table
    in:
      table: concatenate/result
      name:
        valueFrom: "hmmer_table"
    out:
      ouput_table

outputs:
  output_table:
    type: File
    outputSource: post_processing/table
