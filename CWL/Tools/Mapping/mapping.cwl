#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Viral contig mapping"

requirements:
  DockerRequirement:
    dockerPull: mapping:latest
  InlineJavascriptRequirement: {}

baseCommand: ['Rscript', '/Make_viral_contig_map.R']
arguments: ["-o", "Mapping_results"]

inputs:
  input_table:
    type: File
    inputBinding:
      separate: true
      prefix: "-t"

outputs:
  stdout: stdout
  stderr: stderr
  folder:
    type: Directory
    outputBinding:
      glob: Mapping_results

  #mapping_results:
  #  type:
  #    type: array
  #    items: File
  #  outputBinding:
  #    glob: $(inputs.outdir+"/"+"*.pdf")