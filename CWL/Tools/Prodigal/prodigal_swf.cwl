cwlVersion: v1.0
class: Workflow

label: "Prodigal"

doc: |
  SubWorkflow for prodigal.
  Protein-coding gene prediction for prokaryotic genomes.

requirements:
  InlineJavascriptRequirement: {}

inputs:
  high_confidence_contigs:
    type: File?
  low_confidence_contigs:
    type: File?
  prophages_contigs:
    type: File?

steps:
  high_confidence_prodigal:
    run: prodigal.cwl
    in:
      input_fasta: high_confidence_contigs
    out:
      - output_fasta
  low_confidence_prodigal:
    run: prodigal.cwl
    in:
      input_fasta: low_confidence_contigs
    out:
      - output_fasta
  prophages_prodigal:
    run: prodigal.cwl
    in:
      input_fasta: prophages_contigs
    out:
      - output_fasta

outputs:
  high_confidence_contigs_genes:
    outputSource: high_confidence_prodigal/output_fasta
    type: File?
  low_confidence_contigs_genes:
    outputSource: low_confidence_prodigal/output_fasta
    type: File?
  prophages_contigs_genes:
    outputSource: prophages_prodigal/output_fasta
    type: File?
