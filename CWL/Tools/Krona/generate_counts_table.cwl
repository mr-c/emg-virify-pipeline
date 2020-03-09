cwlVersion: v1.0
class: CommandLineTool

label: Convert the assing taxonomy table

baseCommand: "generate_counts_table.py"

requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  assign_table:
    type: File
    label: Tab-delimited text file
    inputBinding:
      prefix: "-f"

arguments:
  - "-o"
  - $( inputs.assign_table.nameroot + "_tax_counts.tsv" )

outputs:
  count_table:
    type: File
    outputBinding:
      glob: "*_tax_counts.tsv"
