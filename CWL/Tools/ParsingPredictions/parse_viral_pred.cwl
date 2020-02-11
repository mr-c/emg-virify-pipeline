cwlVersion: v1.0
class: CommandLineTool

label: "Parse predictions"

#hints:
#  DockerRequirement:
#    dockerPull: mhoelzer/cwl_parse_pred:0.1

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ['parse_viral_pred.py']

inputs:
  assembly:
    type: File
    inputBinding:
      separate: true
      prefix: "-a"
  virfinder_tsv:
    type: File?
    inputBinding:
      separate: true
      prefix: "-f"
  virsorter_dir:
    type: Directory
    inputBinding:
      separate: true
      prefix: "-s"
  output_dir:
    type: string?
    inputBinding:
      separate: true
      prefix: "-o"

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  high_confidence_contigs:
    type: File?
    outputBinding:
      glob: "high_confidence_putative_viral_contigs.fna"
  low_confidence_contigs:
    type: File?
    outputBinding:
      glob: "low_confidence_putative_viral_contigs.fna"
  prophages_contigs:
    type: File?
    outputBinding:
      glob: "putative_prophages.fna"

doc: |
  usage: parse_viral_pred.py [-h] -a ASSEMB -f FINDER -s SORTER [-o OUTDIR]

  description: script generates three output_files: high_confidence.fasta, low_confidence.fasta, Prophages.fasta

  optional arguments:
  -h, --help            show this help message and exit
  -a ASSEMB, --assemb ASSEMB
                        Metagenomic assembly fasta file
  -f FINDER, --vfout FINDER
                        Absolute or relative path to VirFinder output file
  -s SORTER, --vsdir SORTER
                        Absolute or relative path to directory containing
                        VirSorter output
  -o OUTDIR, --outdir OUTDIR
                        Absolute or relative path of directory where output
                        viral prediction files should be stored (default: cwd)
