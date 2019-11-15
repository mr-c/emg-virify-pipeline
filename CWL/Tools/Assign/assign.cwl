#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Viral contig assign"

hints:
  DockerRequirement:
    dockerPull: mhoelzer/assign_taxonomy:0.1

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ['python', '/contig_taxonomic_assign.py']

inputs:
  input_table:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  assign_table:
    type: File
    outputBinding:
      glob: "*tax_assign.tsv"