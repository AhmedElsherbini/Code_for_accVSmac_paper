library("reshape2")
library("ComplexHeatmap")
library("gplots")
####################################3
setwd("/home/ahmed/0_data/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/1_analysis_fastani_fastaai/6_new_12_17_PCR_run/")
### get data, convert to matrix
x <- read.table("fastani_output.txt")

#x = subset(x, x$V1 != "CA_SH_181.fna" & x$V2 != "CA_SH_181.fna") 

matrix <- acast(x, V1~V2, value.var="V3")
matrix[is.na(matrix)] <- 70

### define the colors within 2 zones
breaks = seq(min(matrix), max(100), length.out=100)
gradient1 = colorpanel( sum( breaks[-1]<=95 ), "red", "white" )
gradient2 = colorpanel( sum( breaks[-1]>95 & breaks[-1]<=100), "white", "blue" )

hm.colors = c(gradient1, gradient2)
heatmap.2(matrix, labRow = TRUE, labCol = TRUE, scale = "none", trace = "none", col = hm.colors, cexRow=.44, cexCol=.44)