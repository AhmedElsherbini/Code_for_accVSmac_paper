#author: Ahmed Elsherbini
##############################################################################
library(ggplot2)
library(ggpubr)
#library(PairViz)
library(rstatix)
library(tidyverse)
library(ggsignif)
library(xlsx)
library(dplyr)
library(patchwork)
library(e1071)
##############################################################################
setwd("//home/ahmed/0_data/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/graphs/R_scripts/3_BAKTA/")

##############################################################################

df = read.xlsx2("Bakta_stats.xlsx",sheetIndex = 4)
df = df[!apply(df == "", 1, all),]



####################################################################
df$GC = as.numeric(df$GC)
result <- shapiro.test(df$GC)

if (result$p.value < 0.05) {
  cat("The data is NOT normally distributed, use Wilcox test** (p =", result$p.value, ")\n")
} else {
  cat("The data is normally distributed, Use T test** (p =", result$p.value, ")\n")
}

p2 <- ggplot(df, aes(x = df$Species, y = df$GC, fill = df$Species)) +
  ylab("GC%")+
  xlab("Species")+
  geom_boxplot(alpha = 0.5 ) +
  geom_dotplot(binaxis= "y",
               stackdir = "center",
               dotsize = 0.1,
               fill = 1) +
  ggtitle("GC%")+
  theme(legend.position = "none") +
  ylim(57,60) +
  scale_fill_manual(values = c("#008000","#FFAC1C","#DC143C","#d357fe","#cfe2f3"))+
  
  theme_classic() +
  theme(legend.position="none",plot.title = element_text(hjust = 0.5))+
  geom_signif(comparisons = list(c("CM", "CA_I")),map_signif_level = TRUE, textsize = 8,cex.axis=20,test = t.test) 


p2
