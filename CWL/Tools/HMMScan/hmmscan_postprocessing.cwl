cwlVersion: v1.0
class: CommandLineTool

label: "hmmscan table format"

doc: |
  Format the hmmscan table results table.

  Usage: hmmscan_postprocessing.sh input_table.tsv output_name

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["hmmscan_postprocessing.sh"]

inputs:
  input_table:
    type: File
    inputBinding:
      position: 1
  output_name:
    type: File
    inputBinding:
      position: 2

stdout: stdout.txt
stderr: stderr.txt

outputs:
  output_table:
    type: File
    outputBinding:
      glob: $(inputs.output_name).tsv

