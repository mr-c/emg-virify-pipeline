cwlVersion: v1.0
class: Workflow

label: ViPhOG annotations

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  input_fastas:
    type:
      type: array
      items: ["File", "null"]
    doc: |
      FASTA Protein files
  hmmer_table:
    type: File
    doc: |
      HMMER concatenated tsv

steps:
  viral_annotation:
    run: viral_annotation.cwl
    scatter: input_fasta
    label: contigs annotation
    in:
      input_fasta: input_fastas
      input_table: hmmer_table
    out:
      - annotation_table

outputs:
  annotation_tables:
    outputSource: viral_annotation/annotation_table
    type: File[]

doc: |
  "Run viral_contigs_annotation.py on an array of files"