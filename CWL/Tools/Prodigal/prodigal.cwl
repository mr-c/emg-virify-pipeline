#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool


label: "Protein-coding gene prediction for prokaryotic genomes"

hints:
  DockerRequirement:
    dockerImageId: /hps/nobackup2/singularity/mhoelzer/mhoelzer-prodigal-viral-0.1.img
    dockerPull: mhoelzer/prodigal_viral:0.1

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [prodigal]
arguments:
  - prefix: -p
    valueFrom: "meta"
  - prefix: -a
    valueFrom: $(inputs.input_fasta.nameroot)_prodigal.faa

inputs:
  input_fasta:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output_fasta:
    type: File
    outputBinding:
      glob: "*_prodigal.faa"

