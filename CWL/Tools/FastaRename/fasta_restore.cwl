cwlVersion: v1.0
class: CommandLineTool

label: "Fasta name restore utility"

doc: |
  Python script to restore the names on a multi-fasta using the name mapping file.
  In order to rename the multi-fasta use fasta_rename.cwl

baseCommand: ["rename_fasta.py"]

inputs:
  input:
    type: File?
    inputBinding:
      prefix: "--input"
  name_map:
    type: File
    inputBinding:
      prefix: "--map"

arguments:
  - prefix: "--output"
    valueFrom: "restored.fasta"
  - valueFrom: "restore"
    position: 3

outputs:
  restored_fasta:
    type: File?
    outputBinding:
      glob: "restored.fasta"
 
stdout: stdout.txt
stderr: stderr.txt