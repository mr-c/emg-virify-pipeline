#!/usr/bin/env python3

import argparse
import glob
import operator
import os
import re
import sys

import pandas as pd
from ete3 import NCBITaxa


def contig_tax(annot_df, ncbi_db, min_prot, prop_annot, tax_thres):
    '''This function takes the annotation table generated by viral_contig_maps.py and generates a table that
       provides the taxonomic lineage of each viral contig, based on the corresponding ViPhOG annotations'''

    ncbi = NCBITaxa(dbfile=ncbi_db)
    tax_rank_order = ["genus", "subfamily", "family", "order"]
    contig_list = list(annot_df["Contig"].value_counts().index)
    df_rows = []

    def get_tax_rank(label):
        try:
            tax_id = ncbi.get_name_translator([label])[label]
            tax_rank = ncbi.get_rank(tax_id)[tax_id[0]]
        except:
            tax_rank = ""
        return tax_rank

    for contig in contig_list:
        assigned_taxa = []
        assigned_taxa.append(contig)
        contig_df = annot_df[annot_df["Contig"] == contig]
        filtered_df = contig_df[contig_df["Label"].notnull()]
        filtered_df = filtered_df.reset_index(drop=True)
        total_annot_prot = len(filtered_df)
        if total_annot_prot < max(min_prot, prop_annot * len(contig_df)):
            assigned_taxa.extend([""]*4)
        else:
            filtered_df["Rank"] = filtered_df["Label"].apply(get_tax_rank)
            for item in tax_rank_order:
                tax_hits = {}
                if item == "genus":
                    for row, column in filtered_df.iterrows():
                        if column["Rank"] == item:
                            if column["Label"] not in tax_hits.keys():
                                tax_hits[column["Label"]] = 1
                            else:
                                tax_hits[column["Label"]] += 1
                    if len(tax_hits) < 1:
                        assigned_taxa.append("")
                    else:
                        annot_ratio = max(tax_hits.items(), key=operator.itemgetter(1))[
                            1]/total_annot_prot
                        if annot_ratio < tax_thres:
                            assigned_taxa.append(str(annot_ratio))
                        else:
                            max_tax = []
                            for key, value in tax_hits.items():
                                if value == max(tax_hits.items(), key=operator.itemgetter(1))[1]:
                                    max_tax.append(key)
                            if len(max_tax) > 1:
                                assigned_taxa.append("-".join(max_tax))
                            else:
                                assigned_taxa.append(max_tax[0])
                else:
                    for row, column in filtered_df.iterrows():
                        if column["Rank"] == item:
                            if column["Label"] not in tax_hits.keys():
                                tax_hits[column["Label"]] = 1
                            else:
                                tax_hits[column["Label"]] += 1
                        else:
                            try:
                                name2taxid = ncbi.get_name_translator(
                                    [column["Label"]])
                                label_lineage = ncbi.get_lineage(
                                    name2taxid[column["Label"]][0])
                                lineage_names = ncbi.get_taxid_translator(
                                    label_lineage)
                                lineage_ranks = ncbi.get_rank(label_lineage)
                                if item in lineage_ranks.values():
                                    for x, y in lineage_ranks.items():
                                        if y == item:
                                            if lineage_names[x] not in tax_hits.keys():
                                                tax_hits[lineage_names[x]] = 1
                                            else:
                                                tax_hits[lineage_names[x]] += 1
                                            break
                            except:
                                continue

                    if len(tax_hits) < 1:
                        assigned_taxa.append("")
                    else:
                        annot_ratio = max(tax_hits.items(), key=operator.itemgetter(1))[
                            1]/total_annot_prot
                        if annot_ratio < tax_thres:
                            assigned_taxa.append(str(annot_ratio))
                        else:
                            max_tax = []
                            for key, value in tax_hits.items():
                                if value == max(tax_hits.items(), key=operator.itemgetter(1))[1]:
                                    max_tax.append(key)
                            if len(max_tax) > 1:
                                assigned_taxa.append("-".join(max_tax))
                            else:
                                assigned_taxa.append(max_tax[0])
        df_rows.append(assigned_taxa)
    final_df = pd.DataFrame(
        df_rows, columns=["contig_ID", "genus", "subfamily", "family", "order"])
    return final_df


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="Generate tabular file with taxonomic assignment of viral contigs based on ViPhOG annotations")
    parser.add_argument("-d", "--db", dest="ncbi_db",
                        help="path to the ete3 processed NCBI taxonomy db.")
    parser.add_argument("-i", "--input", dest="input_file",
                        help="Annotation table generated with script viral_contig_maps.py", required=True)
    parser.add_argument("--minprot", dest="min_prot", type=int,
                        help="Minimum number of proteins with ViPhOG annotations required for taxonomic assignment (used when --percent is lower than this value, default: 3)", default=3)
    parser.add_argument("--prop", dest="prot_prop", type=float,
                        help="Minimum proportion of proteins in a contig that must have a ViPhOG annotation in order to provide a taxonomic assignment (default: 0.2)", default=0.2)
    parser.add_argument("--taxthres", dest="tax_thres", type=float,
                        help="Minimum proportion of annotated genes required for taxonomic assignment (default: 0.6)", default=0.6)
    parser.add_argument("-o", "--outdir", dest="outdir",
                        help="Relative path to directory where you want the output file to be stored (default: cwd)", default=".")
    if len(sys.argv) == 1:
        parser.print_help()
    else:
        args = parser.parse_args()
        input_df = pd.read_csv(args.input_file, sep="\t")
        output_df = contig_tax(input_df, args.ncbi_db, args.min_prot,
                               args.prot_prop, args.tax_thres)
        output_df.to_csv(os.path.join(args.outdir, re.split(
            r"\.[a-z]+$", os.path.basename(args.input_file))[0] + "_tax_assign.tsv"), sep="\t", index=False)
