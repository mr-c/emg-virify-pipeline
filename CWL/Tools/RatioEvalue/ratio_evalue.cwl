#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Ratio Evalue table"

hints:
  DockerRequirement:
    dockerPull: mhoelzer/ratio_evalue:0.1

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ['ratio_evalue_table.py']
arguments: ["-o", $(runtime.outdir)]

inputs:
  input_table:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"
  taxa_dict:
    type: File
    inputBinding:
      separate: true
      prefix: "-t"

outputs:
  stdout: stdout
  stderr: stderr

  informative_table:
    type: File
    outputBinding:
      glob: "*informative.tsv"


stdout: stdout.txt
stderr: stderr.txt
