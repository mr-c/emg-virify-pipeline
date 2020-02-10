cwlVersion: v1.0
class: Workflow

label: "Hmm scan subworkflow of the viral pipeline"

requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  aa_fasta_files:
    type: File[]
    doc: "FASTA Protein files"
  database:
    type: Directory

steps:
  hmmscan:
    run: hmmscan.cwl
    scatter: aa_fasta_file
    label: "Run HMMR Scan."
    in:
      aa_fasta_file: aa_fasta_files
      database: database
    out:
      - output_table
  concatenate:
    run: ../Utils/concatenate.cwl
    label: "CAT the tables"
    in:
      files: hmmscan/output_table
      name:
        valueFrom: ${ return "hmmer_table.tsv" }
    out:
      - result

outputs:
  output_table:
    type: File
    outputSource: concatenate/result
