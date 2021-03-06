cwlVersion: v1.0
class: Workflow

label: IMG/VR blast

doc: |
  Run blast against IMG/VR

requirements:
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  fasta_files:
    type:
      type: array
      items: ["null", "File"]
    doc: FASTA files
  database:
    type: Directory
    doc: IMG/VR blast db

steps:
  blast:
    run: imgvr_blast.cwl
    scatter: query
    label: Run blastn
    in:
      query: fasta_files
      database: database
    out:
      - blast_result
      - blast_result_filtered
  merge_data:
    run: imgvr_merge.cwl
    scatter: blast_results_filtered
    label: Merge
    in:
      blast_results_filtered: blast/blast_result_filtered
      database: database
      outfile:
        valueFrom: $(inputs.blast_results_filtered.nameroot + "_merged.tsv")
    out:
      - merged_tsv
    doc: |
      Combine the filtered blast results with meta information from the IMG/VR database.

outputs:
  blast_results:
    type: File[]
    outputSource: blast/blast_result  
  blast_result_filtereds:
    type: File[]
    outputSource: blast/blast_result_filtered
  merged_tsvs:
    type: File[]
    outputSource: merge_data/merged_tsv
