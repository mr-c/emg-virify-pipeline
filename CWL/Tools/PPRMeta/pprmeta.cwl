cwlVersion: v1.0
class: CommandLineTool

label: "PPR-Meta"

requirements:
  InlineJavascriptRequirement: {}

inputs:
  fasta_file:
    type: File
    label: contigs
    inputBinding:
      prefix: "-f"

baseCommand: "pprmeta.sh"

arguments:
  - "-o"
  - $( runtime.outdir + "/" + inputs.fasta_file.nameroot + "_pprmeta.csv" )

outputs:
  pprmeta_output:
    type: File
    format: iana:text/csv
    outputBinding:
      glob: "*.csv"

$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"