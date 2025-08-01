rm(list=ls())
source('analysis_deseq_rnaseq.R', chdir = TRUE)
setwd('analysis_count_table_diff_expression')
path_gff <- "/ncbi_dataset/data/GCF_000478135.1/genomic.gff"
path_count_table <- "analysis_count_table_diff_expression/counts_all.txt"


# read featureCounts table and round the values
count_table <- read.table(path_count_table, sep="\t", header = T)
count_table[,8:13] <- round(count_table[,8:13])
sum_reads <- colSums(count_table[,8:13])

# export the rounded table
write.table(count_table, "counts_all_rounded.txt", sep="\t", quote = F, row.names = F)
# save rounded path
path_count_table <- "counts_all_rounded.txt"

results_deseq <- main(path_gff, path_count_table, "DEseq_TPM_results_CA_RNASeq.csv", "CA")


