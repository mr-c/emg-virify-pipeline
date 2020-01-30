#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Viral contig assign"

#hints:
#  DockerRequirement:
#    dockerPull: mhoelzer/assign_taxonomy:0.1

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ['contig_taxonomic_assign.py']

inputs:
  input_table:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"
  ncbi_tax_db:
    type: File
    inputBinding:
      prefix: "-d"
    doc: |
      ete3 NCBITaxa db https://github.com/etetoolkit/ete/blob/master/ete3/ncbi_taxonomy/ncbiquery.py
      http://etetoolkit.org/docs/latest/tutorial/tutorial_ncbitaxonomy.html
      This file was manually built and placed in the corresponding path (on databases)

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  assign_table:
    type: File
    outputBinding:
      glob: "*tax_assign.tsv"
