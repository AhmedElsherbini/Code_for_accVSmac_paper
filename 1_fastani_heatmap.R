library("reshape2")
library("ComplexHeatmap")
library("gplots")
####################################3
setwd("/media/ahmed/CC69-620B6/00_Ph.D/DATA_results/2_medium_project/0_accolens_prop_database_work/0_analysis/1_analysis_fastani_fastaai/y_new_2_12")
### get data, convert to matrix
x <- read.table("fastani_output.txt")
matrix <- acast(x, V1~V2, value.var="V3")
matrix[is.na(matrix)] <- 70

### define the colors within 2 zones
breaks = seq(min(matrix), max(100), length.out=100)
gradient1 = colorpanel( sum( breaks[-1]<=95 ), "red", "white" )
gradient2 = colorpanel( sum( breaks[-1]>95 & breaks[-1]<=100), "white", "blue" )

hm.colors = c(gradient1, gradient2)
heatmap.2(matrix, scale = "none", trace = "none", col = hm.colors, cexRow=.44, cexCol=.44)