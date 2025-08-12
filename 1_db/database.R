library(forcats)
library(ggplot2)
library(dplyr)
library(xlsx)
library(patchwork)
#http://www.sthda.com/english/wiki/ggplot2-barplots-quick-start-guide-r-software-and-data-visualization

setwd("/home/ahmed/0_data/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/graphs/R_scripts/1_db/")

df <- as.data.frame(read.csv("spp_heatma_red.csv", check.names = FALSE))

df$Prev. = as.numeric(df$Prev.) 

# Basic barplot

df$Prev. = as.numeric(df$Prev.) 



p1 <- ggplot(df, aes(reorder(Sample, Prev.), Prev.)) + geom_col(position = "dodge")+
  coord_flip() +
  xlab("Microbiome")+
  ylab("% Prev. in curatedMetagenomicData database (human)")+
  theme(text = element_text(size=18))+
  geom_text(aes(label=round(Prev., digits = 2)),hjust=-0.25, ,vjust=.45,size = 8)+
  ylim(0,80)



p1

df2 <- as.data.frame(read.csv("non-human.csv", check.names = FALSE))

df2$Prev. = as.numeric(df2$Prev.) 

# Basic barplot



p2 <- ggplot(df2, aes(reorder(Sample, Prev.), Prev.)) + geom_col(position = "dodge")+
  coord_flip() +
  xlab("Microbiome")+
  ylab("% Prev. in IMNGS database (non-human)")+
  theme(text = element_text(size=18))+
  geom_text(aes(label=round(Prev., digits = 2)),hjust=-0.25, vjust=.45,size = 8)+
  ylim(0,65)

p2
final_plot <- (p1+p2 ) + 
  plot_layout(ncol = 2, nrow = 1) + 
  plot_annotation(tag_levels = 'A')  # Labels panels as A, B, C, D, E

# Display the final plot
print(final_plot)