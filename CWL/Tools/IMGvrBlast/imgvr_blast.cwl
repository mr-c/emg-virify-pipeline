cwlVersion: v1.0
class: CommandLineTool

label: "blast against IMG/VR"

requirements:
  InlineJavascriptRequirement: {}

inputs:
  database:
    type: Directory
    inputBinding:
      prefix: "-d"
  query:
    type: File?
    inputBinding:
      prefix: "-q"

arguments: 
  - prefix: "-o"
    valueFrom: |
      ${
        if (inputs.query && inputs.query.nameroot) {
          return inputs.query.nameroot + "_imgvr_blast";
        } else {
          return "empty_imgvr_blast";
        }
      }
  - prefix: "-c"
    valueFrom: $(parseInt(runtime.cores))

baseCommand: "imgvr_blast.sh"

stdout: stdout
stderr: stderr 

outputs:
  blast_result:
    type: File
    outputBinding:
      glob: $("*_imgvr_blast.tsv")
  blast_result_filtered:
    type: File
    outputBinding:
      glob: $("*_imgvr_blast_filtered.tsv")

$namespaces:
 s: http://schema.org/
$schemas:
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"