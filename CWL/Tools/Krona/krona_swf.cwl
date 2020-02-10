cwlVersion: v1.0
class: Workflow

label: "Krona"

requirements:
  ScatterFeatureRequirement: {}

inputs:
  assign_tables:
    type: File[]
    doc: "Assign tsv table"

steps:
  convert_table:
    run: generate_counts_table.cwl
    label: "Convert table for Krona"
    scatter: assign_table
    in:
      assign_table: assign_tables
    out:
      - count_table
  krona:
    run: krona.cwl
    label: "Krona ktImportText"
    scatter: otu_counts
    in:
      otu_counts: convert_table/count_table
    out:
      - krona_html

outputs:
  krona_html:
    outputSource: krona/krona_html
    type: File[]
