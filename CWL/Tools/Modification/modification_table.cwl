cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: mhoelzer/sed_docker:0.1

baseCommand: ['sed', '/^#/d; s/ \+/\t/g']

inputs:
  table_for_modification:
    type: File
    inputBinding:
      separate: true
      position: 2

outputs:
  output_with_tabs:
    type: stdout
