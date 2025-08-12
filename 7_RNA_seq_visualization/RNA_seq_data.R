

# Load DESeq2 results
# Load library
library(ggplot2)
library(tibble)
#> Warning: package 'tibble' was built under R version 3.4.3
library(forcats)
library(dplyr)
library(tidyr)
library(patchwork)
# Load DESeq2 results
setwd("/home/ahmed/0_data/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/graphs/R_scripts/7_RNA_seq_visualization/")
df <- read.csv("1_DEseq_TPM_results_CA_RNASeq_sorted_logFC.csv", header=TRUE)  # Use read.csv for CSV files
# Define a list of known genes (you should replace this with your actual gene list)
known_genes_df = read.csv("1_gen_list.csv")

known_genes <- c(known_genes_df$gene)

# Create a new column to indicate whether the gene is in the known_genes list
df$highlight <- ifelse(df$Gene_names %in% known_genes, "Known Gene", "Other")

p <- ggplot(df, aes(x = log2FoldChange, y = -log10(padj), color = highlight)) +
  geom_point() +  # Simple points
  scale_color_manual(
    values = c("Known Gene" = "red"),  # Color mapping
    labels = c("Known Gene" = "Iron acquisition annotated genes"),  # Legend labels
    name = "Gene Category"  # Legend title
  ) +
  theme_minimal() +  # Minimal theme
  labs( x = "Log2 Fold Change", 
       y = "-Log10 Adjusted p-value") +  # Axis labels
  theme(
    legend.position = "right",  # Show legend on the right
    panel.grid.major = element_blank(),  # Remove major grid lines
    panel.grid.minor = element_blank(),  # Remove minor grid lines
    axis.title.x = element_text(size = 12),  # Customize x-axis label size
    axis.title.y = element_text(size = 12),  # Customize y-axis label size
    axis.text.x = element_text(size = 10),  # Customize x-axis text size
    axis.text.y = element_text(size = 10)   # Customize y-axis text size
  ) +
  
  # Add vertical dashed line at x = 0 (log2FoldChange = 0) to separate upregulated and downregulated
  geom_vline(xintercept = 0, color = "black", linetype = "dashed", size = 1) +
  
  # Optional: Add horizontal line for significance threshold (adjust as needed)
  geom_hline(yintercept = -log10(0.05), color = "blue", linetype = "dashed", size = 1) +
  
  # Ensure all points are shown
  expand_limits(x = c(min(df$log2FoldChange), max(df$log2FoldChange)),
                y = c(min(-log10(df$padj)), max(-log10(df$padj))))


p <- p + coord_cartesian(clip = "off")  # Prevents points from being clipped

# Print the plot
print(p)



df = data.frame(read.csv("2_data.csv"),check.names = FALSE)

df$Iron_acquisition_annotated_genes <- factor(df$Iron_acquisition_annotated_genes, levels = c("Heme_transport","Siderophore_transport","Iron_transport","Iron_genes_regulation","Iron_storage"))

df$significance <- ifelse(df$adjp < 0.001, "***",
                          ifelse(df$adjp < 0.01, "**",
                                 ifelse(df$adjp < 0.05, "*", "")))

p2 <- ggplot(df, aes(x = reorder(gene_name, logf2c), y = logf2c, fill = Iron_acquisition_annotated_genes)) +
  geom_col() +
  geom_hline(yintercept = 0, linetype = "dashed") +  
  geom_text(aes(label = significance, y = logf2c + sign(logf2c) * 2), 
            size = 6, color = "black") +  
  #geom_point(aes(shape = df$Spp.), position = position_dodge(width = 0.5), 
   #          size = 5, color = "green") +  # Black dots for groups in the plot
  coord_flip() +
  scale_y_continuous(limits = c(-5, 14)) +  
  #scale_shape_manual(values = c("CA_I" = 16,"CA_only"=13)) +  
  #guides(
    #fill = guide_legend(override.aes = list(shape = NA, color = NA)),  # Removes color from cat legend
    #shape = guide_legend(title = "Group")  # Keeps group shape legend) +
  labs(x = "gene_name", y = "Log2 Fold Change") +
  theme(text = element_text(size = 20))+
  theme_minimal()


p2

final_plot <- (p + p2 ) + 
  plot_layout(ncol = 2, nrow = 1) + 
  plot_annotation(tag_levels = 'A')  # Labels panels as A, B, C, D, E

# Display the final plot
print(final_plot)
