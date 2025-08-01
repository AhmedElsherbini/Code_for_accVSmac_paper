rm(list=ls())
library(DESeq2)
library(ggplot2)
library(vsn)

library(hexbin)

compute_tpm <-function(counts, lengths){
  lengths_in_kb <- lengths / 1000
  rpk_values <-  counts / lengths_in_kb
  sf <- sum(rpk_values) / (10^6)
  tpm_values <- rpk_values / sf
  return(tpm_values)
}



results_deseq <- function(res, dds, output_dir) {
  # remove NA values
  res <- res[complete.cases(res),]
  res <- res[order(res$padj),]
  minmal_padj <- min(res[res$padj >0,]$padj)
  res$padj_adapted <- ifelse(res$padj == 0, minmal_padj, res$padj)

  # print the number of significant genes
  print(paste("Number of diff. expressed genes:", nrow(subset(res, padj < 0.01))))
  sig_pos_change <- subset(res, padj < 0.01 & log2FoldChange > 0)
  sig_neg_change <- subset(res, padj < 0.01 & log2FoldChange < 0)
  sig_large_pos_change <- subset(res, padj < 0.01 & log2FoldChange >= 2)
  sig_large_neg_change <- subset(res, padj < 0.01 & log2FoldChange <= (-2))

  # print the number of significant genes
  print(paste("Number of significantly up-regulated genes:", nrow(sig_pos_change)))
  print(paste("Number of significantly down-regulated genes:", nrow(sig_neg_change)))
  print(paste("Number of significantly up-regulated genes with log2FC >= 2:", nrow(sig_large_pos_change)))
  print(paste("Number of significantly down-regulated genes with log2FC <= -2:", nrow(sig_large_neg_change)))
  

  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }
  
  # Save volcano plot as jpg
  volcano_plot_file <- file.path(output_dir, "volcano_plot.jpg")
  jpeg(volcano_plot_file, width = 500, height = 220, quality = 100)
  plot(res$log2FoldChange, -log10(res$padj_adapted), pch = 4, 
   main =NULL, 
  col = "gray", 
  xlab = "log2FC: log2(treat) - log2(control)",
  ylab = "-log10(padj)"
  # increase y axis
  , ylim = c(0, 350)
  )
  points(sig_pos_change$log2FoldChange, -log10(sig_pos_change$padj_adapted), pch = 4, col = "pink")
  points(sig_neg_change$log2FoldChange, -log10(sig_neg_change$padj_adapted), pch = 4, col = "lightblue")
  points(sig_large_pos_change$log2FoldChange, -log10(sig_large_pos_change$padj_adapted), pch = 4, col = "red")
  points(sig_large_neg_change$log2FoldChange, -log10(sig_large_neg_change$padj_adapted), pch = 4, col = "blue")
  dev.off()
  
  # Save PCA plot as jpg
  pca_plot_file <- file.path(output_dir, "pca_plot.jpg")
  jpeg(pca_plot_file, width = 432, height = 180, quality = 100)
  vsdata <- vst(dds, blind = FALSE)
  test <- plotPCA(vsdata, intgroup = "dex", ntop = 2000)
  print(test)
  dev.off()
  
  # Print the file paths of the saved figures
  print(paste("Volcano plot saved as:", volcano_plot_file))
  print(paste("PCA plot saved as:", pca_plot_file))
}

split_name <- function(word, filt){
  return(unlist(strsplit(Filter(function(y) return(grepl(filt, y, fixed=T)),word), "="))[2])
}
to_gene_name_desc <- function(x){
  splitted <- unlist(strsplit(x, ";"))
  gene_locus <- split_name(splitted, "ID")
  parent <- split_name(splitted, "Parent")
  # if ID starts with 
  gene_name <-  split_name(splitted, "Name")
  gene_product <-  split_name(splitted, "product")
  return(c(gene_locus, gene_product, parent))
}

main <- function(path_gff, path_count_table, outputFile = "DEseq_TPM_results.csv", speciesName = "species"){
  # Read GFF that has been previously splittet to not containt FASTA eintries
  read_gff <- read.table(path_gff, sep="\t", quote="" )
  # filter if V3 has CDS, tRNA or rRNA
  read_gff <- read_gff[read_gff$V3 %in% c("CDS", "tRNA", "rRNA"),]
  # Get the gene name and description
  read_gff$locus_id <- apply(read_gff, 1, function(x) return(gsub(".t01", "", to_gene_name_desc(x[9])[3])))
  read_gff$description <- apply(read_gff, 1, function(x) return(to_gene_name_desc(x[9])[2]))
  print(head(read_gff))
  # Create Mapping for the gene names
  mapping <- hash(read_gff$locus_id, read_gff$description)
  # Create metadata for the DESeq2
  df_metadata <- data.frame(id=c(paste0("control", c(1,2,3)), paste0("treat", 1:3)), dex=c(rep("control", 3), rep("treated",3)))
  count_table_reads <- read.table(path_count_table, sep="\t", header = T)

  # Rename the columns to have the correct names
  temp <- colnames(count_table_reads)
  temp[8:13] <- c(paste0("control", c(1,2,3)), paste0("treat", 1:3))
  colnames(count_table_reads) <- temp

  # Check mean
  apply(count_table_reads[,8:13], 2,mean)

  df_count_table_just_reads <- count_table_reads[,c(1,8:13)]
  df_count_table_just_reads[,-1] <-df_count_table_just_reads[,-1] +1

  df_counts_TPM <- df_count_table_just_reads
  df_counts_TPM$genelength <-  count_table_reads$Length
  df_counts_TPM[,2:7] <- apply(df_counts_TPM[,2:7], 2, function(x) compute_tpm(x, df_counts_TPM$genelength))

  # export TPM dataframe
  df_export <- df_counts_TPM[,c(1,2:7)]
  df_export[,2:7] <- log2(df_export[,2:7]+1)
  write.csv(df_export, paste0("TPM_", speciesName,".csv"), row.names = FALSE)
  
  # Check the distribution of the TPM values
  # export following figure
  png("Figures/boxplot_log2_TPM.png", width = 1200, height = 1600, res = 300)
  boxplot(log2(df_counts_TPM[,2:7]), 
    main = "Boxplot of log2(TPM)"
  )
  dev.off()
  png("Figures/boxplot_TPM.png", width = 1200, height = 1600, res = 300)
    boxplot(df_counts_TPM[,2:7], 
    main = "Boxplot of TPM"
  )
  dev.off()

  df_counts_TPM$avgTPMControl <- apply(df_counts_TPM[,2:4],1,mean)
  df_counts_TPM$avgTPMTreat <- apply(df_counts_TPM[,5:7],1,mean)
  df_counts_TPM$avgTPMAll <- apply(df_counts_TPM[,2:7],1,mean)
 
  boxplot(log2(df_count_table_just_reads[-1]), 
  # increase font size
  cex.axis = 2.5, cex.lab = 2.5, cex.main = 2.5
  )

  # Create DESeq2 dataset
  deseq_dataset <- DESeqDataSetFromMatrix(df_count_table_just_reads, colData = df_metadata, design =~dex, tidy = T)
  deseq_dataset  <- DESeq(deseq_dataset )
  # Get the normalized counts
  export_normalized_counts <- log2(counts(deseq_dataset,normalized=TRUE)+1)
  png("Figures/boxplot_logCounts.png", width = 1200, height = 1600, res = 300)
    boxplot(export_normalized_counts, 
  # increase font size
  main = "Boxplot of Shifted Log-Transform"
  # cex.axis = 2.5, cex.lab = 2.5, cex.main = 2.5
  )
  dev.off()

  png("Figures/meanSD_logCounts.png", width = 1200, height = 1600, res = 300)
    meanSdPlot(export_normalized_counts, ranks = FALSE
  # increase font size
  # cex.axis = 2.5, cex.lab = 2.5, cex.main = 2.5
  )
  dev.off()
  # export the normalized counts
  write.csv(export_normalized_counts, paste0("normalized_counts_",speciesName,".csv"), row.names = TRUE)

  rld <- assay(rlog(deseq_dataset, blind = FALSE))
  png("Figures/boxplot_RLOG.png", width = 1200, height = 1600, res = 300)
    boxplot(rld, 
      main = "Boxplot of RLOG"
    )
  dev.off()
   png("Figures/meanSD_RLOG.png", width = 1200, height = 1600, res = 300)
    meanSdPlot(rld, ranks = FALSE
    )
  dev.off()
  write.csv(rld, paste0("RLE_normalized_",speciesName,".csv"), row.names = TRUE)

  vsdata <- assay(vst(deseq_dataset, blind = FALSE))
    png("Figures/boxplot_VST.png", width = 1200, height = 1600, res = 300)
    boxplot(vsdata, 
  main = "Boxplot of VST"
  )
  dev.off()
     png("Figures/meanSD_VST.png", width = 1200, height = 1600, res = 300)
    meanSdPlot(vsdata, ranks = FALSE
  )
  dev.off()
  # export the normalized counts
  write.csv(vsdata, paste0("VST_normalized_",speciesName,".csv"), row.names = TRUE)

  # Get the results
  result_deseq_df <- results(deseq_dataset )
  # Compute Figures
  results_deseq(result_deseq_df, deseq_dataset, "Figures")
  result_deseq_df$gene_name <- rownames(result_deseq_df)
  result_deseq_df <- data.frame(result_deseq_df)

  subset_df_counts <- df_counts_TPM[,c(1,9,10,11)]
  
  # Join the results with the subset via geneid and index
  merged_results <- merge(result_deseq_df, subset_df_counts, by.x="gene_name", by.y="Geneid", all.x=TRUE)

  #Join the results to get the product
  merged_results <- merge(merged_results, read_gff[,c(10,11)], by.x="gene_name", by.y="locus_id", all.x=TRUE)
  merged_results <- merged_results[,c(1,11,8,9,10,2:7)]

  # remove duplicates
  merged_results <- merged_results[!duplicated(merged_results$gene_name),]
  # Save the results
  write.csv(merged_results, outputFile, row.names = FALSE)
  # Sort the results by padj
  merged_results <- merged_results[order(merged_results$padj),]
  # Export the results
  write.csv(merged_results, gsub(".csv", "_sorted_pAdj.csv",outputFile), row.names = FALSE)
   # Sort the results by log2FoldChange
  merged_results <- merged_results[order(merged_results$log2FoldChange),]
  # Export the results
  write.csv(merged_results, gsub(".csv", "_sorted_logFC.csv", outputFile), row.names = FALSE)
  return(result_deseq_df)
}

