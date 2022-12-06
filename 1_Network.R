#https://github.com/lmc297/bactaxR
#remotes::install_github("lmc297/bactaxR")
setwd("/media/ahmed/CC69-620B6/00_Ph.D/DATA_results/2_medium_project/4_spp_cross_feeding_epid/c_accolens/analysis/analysis_fastani_fastaai")
library(bactaxR)
ani <- read.ANI(file = "fastani_output.txt")
summary(ani)
h <- ANI.histogram(bactaxRObject = ani, bindwidth = 0.1)

h

?ANI.histogram

dend <- ANI.dendrogram(bactaxRObject = ani, ANI_threshold = 95, xline = c(4,5,6,7.5), xlinecol = c("#ffc425", "#f37735", "deeppink4", "black"), label_size = 0.5)

metadata <- dend$cluster_assignments$Cluster
metadata
dend$cluster_assignments

dend$medoid_genomes

names(metadata) <- dend$cluster_assignments$Genome

?ANI.graph

ANI.graph(bactaxRObject = ani, ANI_threshold = 95,
          metadata = metadata, node_size = 4 ,
          legend_pos_x = -1.5, show_legend = T, graphout_niter = 1000000, 
          legend_ncol = 1, edge_color = "black")
