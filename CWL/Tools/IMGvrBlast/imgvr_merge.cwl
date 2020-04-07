cwlVersion: v1.0
class: CommandLineTool

label: "merge blast with IMG/VR"

requirements:
  InlineJavascriptRequirement: {}

doc: |
  Combine the filtered blast results with meta information from the IMG/VR database.

inputs:
  blast_results_filtered:
    type: File
    inputBinding:
      prefix: "-f"
  database:
    type: Directory
    inputBinding:
      prefix: "-d"
      valueFrom:
        $(self.path + "/IMGVR_all_Sequence_information.tsv")
  outfile:
    type: string
    inputBinding:
      prefix: "-o"

baseCommand: "imgvr_merge.py"

stdout: stdout
stderr: stderr 

outputs:
  merged_tsv:
    type: File
    outputBinding:
      glob: "*.tsv"

$namespaces:
 s: http://schema.org/
$schemas:
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"