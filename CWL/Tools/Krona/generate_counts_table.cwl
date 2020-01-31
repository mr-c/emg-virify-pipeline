cwlVersion: v1.0
class: CommandLineTool

label: Convert the assing taxonomy table

baseCommand: "generate_counts_table.py"

inputs:
  assign_table:
    type: File
    label: Tab-delimited text file
    inputBinding:
      prefix: "-i"

arguments: ["-o", "tax_counts.tsv"]

outputs:
  count_table:
    type: File
    outputBinding:
      glob: "tax_counts.tsv"
