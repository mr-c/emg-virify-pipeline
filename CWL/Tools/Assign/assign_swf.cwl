cwlVersion: v1.0
class: Workflow

label: "Viral contig assign"

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  input_tables:
    type: File[]
  ncbi_tax_db:
    type: File
    doc: |
      "ete3 NCBITaxa db https://github.com/etetoolkit/ete/blob/master/ete3/ncbi_taxonomy/ncbiquery.py
      http://etetoolkit.org/docs/latest/tutorial/tutorial_ncbitaxonomy.html
      This file was manually built and placed in the corresponding path (on databases)"

steps:
  viral_assignation:
    run: assign.cwl
    scatter: input_table
    in:
      input_table: input_tables
      ncbi_tax_db: ncbi_tax_db
    out:
      - assign_table

outputs:
  assign_tables:
    outputSource: viral_assignation/assign_table
    type: File[]
