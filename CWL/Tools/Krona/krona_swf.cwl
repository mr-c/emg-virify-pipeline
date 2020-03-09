cwlVersion: v1.0
class: Workflow

label: "Krona"

requirements:
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  assign_tables:
    type: File[]
    doc: "Assign tsv table"

steps:
  convert_table:
    run: generate_counts_table.cwl
    label: Convert table for Krona
    scatter: assign_table
    in:
      assign_table: assign_tables
    out:
      - count_table  
  krona_individual:
    run: krona.cwl
    label: ktImportText
    scatter: otu_counts
    in:
      otu_counts: convert_table/count_table
    out:
      - krona_html
  concatenate:
    run: ../Utils/concatenate.cwl
    label: CAT the tables
    in:
      files: convert_table/count_table
      name:
        valueFrom: "krona_all.tsv"
    out:
      - result
  krona_all:
    run: krona.cwl
    label: ktImportText
    in:
      otu_counts: concatenate/result
    out:
      - krona_html

outputs:
  krona_all_html:
    outputSource: krona_all/krona_html
    type: File
  krona_htmls:
    outputSource: krona_individual/krona_html
    type: File[]
  table_all:
    outputSource: concatenate/result
    type: File
  tables:
    outputSource: convert_table/count_table
    type: File[]
