cwlVersion: v1.0
class: CommandLineTool

label: "hmmscan table format"

doc: |
  Format the hmmscan table results table.

  Usage: hmmscan_format_table.py -t input_table.tsv -o output_name

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [hmmscan_format_table.py]

inputs:
  input_table:
    type: File
    inputBinding:
      prefix: "-t"
  output_name:
    type: string
    inputBinding:
      prefix: "-o"

stdout: stdout.txt
stderr: stderr.txt

outputs:
  output_table:
    type: File
    outputBinding:
      glob: $(inputs.output_name).tsv

