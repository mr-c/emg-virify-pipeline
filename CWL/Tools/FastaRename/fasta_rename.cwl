cwlVersion: v1.0
class: CommandLineTool

label: "Fasta rename utility"

doc: |
  Small python script to rename a multi-fasta sequences, it's also possible to
  restore the names using the generated map file.
  In order to restore the multi-fasta use fasta_name_restore.cwl.

baseCommand: ["rename_fasta.py"]

inputs:
  input:
    type: File
    inputBinding:
      prefix: "--input"

arguments:
  - prefix: "--output"
    valueFrom: "renamed.fasta"
  - valueFrom: "rename"
    position: 3

outputs:
  renamed_fasta:
    type: File
    outputBinding:
      glob: "renamed.fasta"
  name_map:
    type: File
    outputBinding:
      glob: "fasta_map.tsv"

stdout: stdout.txt
stderr: stderr.txt