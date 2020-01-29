cwlVersion: v1.0
class: CommandLineTool

label: "VirFinder is a method for finding viral contigs from de novo assemblies."

# Output of this tool is saved to file <VirFinder_output.tsv>

#hints:
#  DockerRequirement:
#    dockerPull: mhoelzer/virfinder_viral:0.1

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [run_virfinder.Rscript]
arguments:
  - valueFrom: VirFinder_output.tsv
    position: 2

inputs:
  fasta_file:
    type: File
    inputBinding:
      separate: true
      position: 0

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  output:
    type: File
    outputBinding:
      glob: VirFinder_output.tsv


doc: |
  usage: Rscript run_virfinder.Rscript <input.fasta> <output.tsv>
