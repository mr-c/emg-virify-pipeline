cwlVersion: v1.0
class: CommandLineTool

label: "Protein-coding gene prediction for prokaryotic genomes"

#hints:
#  DockerRequirement:
#    dockerPull: mhoelzer/prodigal_viral:0.1

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [prodigal]

inputs:
  input_fasta:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"

arguments:
  - prefix: -p
    valueFrom: "meta"
  - prefix: -a
    valueFrom: $(inputs.input_fasta.nameroot)_prodigal.faa

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output_fasta:
    type: File
    outputBinding:
      glob: "*_prodigal.faa"
