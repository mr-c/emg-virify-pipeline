#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Preparation for ratio evalue analysis"

requirements:
  DockerRequirement:
    dockerPull: generate_tbl:latest
  InlineJavascriptRequirement: {}

baseCommand: ['python', '/Ratio_Evalue_table.py']

inputs:
  input_table:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"
  outdir:
    type: Directory
    inputBinding:
      separate: true
      prefix: "-o"

outputs:
  informative_table:
    type: File
    outputBinding:
      glob: File*tbl