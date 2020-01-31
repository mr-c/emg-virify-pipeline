cwlVersion: v1.0
class: Workflow

label: visualize using krona

requirements:
  SubworkflowFeatureRequirement: {}

inputs:
  assign_table:
    type: File
    doc: "Assign tsv table"

steps:
  convert_table:
    run: generate_counts_table.cwl
    label: "Convert table for Krona"
    in:
      assign_table: assign_table
    out:
      - count_table
  krona:
    run: krona.cwl
    label: "Krona ktImportText"
    in:
      otu_counts: convert_table/count_table
    out:
      - krona_html

outputs:
  krona_html:
    outputSource: krona/krona_html
    type: File
