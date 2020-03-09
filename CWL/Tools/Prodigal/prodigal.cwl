cwlVersion: v1.0
class: CommandLineTool

label: "Protein-coding gene prediction for prokaryotic genomes"

#hints:
#  DockerRequirement:
#    dockerPull: mhoelzer/prodigal_viral:0.1

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [prodigal_wrapper.sh]

inputs:
  input_fasta:
    type: File?
    inputBinding:
      separate: true
      prefix: "-i"
      position: 1 # needed for wrapper

arguments:
  - prefix: -p
    valueFrom: "meta"
    position: 2
  - prefix: -a
    valueFrom: |
      ${
        if (inputs.input_fasta && inputs.input_fasta.nameroot) {
          return inputs.input_fasta.nameroot + "_prodigal.faa";
        } else {
          return "empty_prodigal.faa";
        }
      }
    position: 3

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output_fasta:
    type: File
    outputBinding:
      glob: "*_prodigal.faa"
