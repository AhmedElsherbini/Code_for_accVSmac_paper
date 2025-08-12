#author: Ahmed Elsherbini
##############################################################################
library(ggplot2)
library(ggpubr)
library(PairViz)
library(rstatix)
library(tidyverse)
library(ggsignif)
library(patchwork)

setwd("/home/ahmed/0_data/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/graphs/R_scripts/5_Iron/")
##############################################################################

#https://cran.r-project.org/web/packages/ggprism/vignettes/pvalues.html

df <- read_csv("boxplot_SIDE_transporters.csv",show_col_types = FALSE)
comparisons_list <- list( c("CA_I","CM"))


df$Species <- as.factor(df$Species)
df$iron_siderophore_transport = as.numeric(df$iron_siderophore_transport)

result <- shapiro.test(df$iron_siderophore_transport)

if (result$p.value < 0.05) {
  cat("The data is NOT normally distributed, use Wilcox test** (p =", result$p.value, ")\n")
} else {
  cat("The data is normally distributed, Use T test** (p =", result$p.value, ")\n")
}


p1 <- ggplot(df, aes(x = Species, y =iron_siderophore_transport , fill = Species)) +
  ylab("No. of proteins") +
  xlab("Clusters/Species") +
  ggtitle("Siderophores transporters") +
  geom_boxplot(alpha = 0.5) +  # Removed `trim = FALSE`
  geom_dotplot(binaxis = "y",
               stackdir = "center",
               dotsize = 0.01,
               fill = 1) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult = 0.1), 
               geom = "pointrange", color = "black") +  # Fixed `mult` argument
  theme_classic() +
  geom_signif(
    comparisons = list(c("CM", "CA_I")),
    map_signif_level = TRUE, textsize = 6, y_position = 45,test =  wilcox.test) +
  ylim(0, 50) +
  scale_fill_manual(values = c("#008000", "#FFAC1C", "#DC143C", "#d357fe", "#cfe2f3")) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5))

# Display the plot
print(p1)



#######################################################################################################

df2 = data.frame(read.csv("boxpolt_iron_transporters.csv"))
df2$Species <- as.factor(df2$Species)
df2$Iron_transporters = as.numeric(df2$Iron_transporters)

result <- shapiro.test(df2$Iron_transporters)

if (result$p.value < 0.05) {
  cat("The data is NOT normally distributed, use Wilcox test** (p =", result$p.value, ")\n")
} else {
  cat("The data is normally distributed, Use T test** (p =", result$p.value, ")\n")
}



p2 <- ggplot(df2, aes(x = Species, y = Iron_transporters, fill = Species)) +
  ylab("No. of proteins") +
  xlab("Clusters/Species") +
  ggtitle("Iron uptake transporters") +
  geom_boxplot(alpha = 0.5) +  # Removed `trim = FALSE`
  geom_dotplot(binaxis = "y",
               stackdir = "center",
               dotsize = 0.01,
               fill = 1) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult = 0.1), 
               geom = "pointrange", color = "black") +  # Fixed `mult`
  theme_classic() +
  geom_signif(
    comparisons = list(c("CM", "CA_I")),
    map_signif_level = TRUE, textsize = 6, y_position = 16,test =  wilcox.test) +  # Removed `cex.axis`
  ylim(0, 18) +
  scale_fill_manual(values = c("#008000", "#FFAC1C", "#DC143C", "#d357fe", "#cfe2f3")) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5))

# Display the plot
print(p2)





#######################################################################################################3
final_plot <- (p1+p2) + 
  plot_layout(ncol = 3, nrow = 1) + 
  plot_annotation(tag_levels = 'A')  # Labels panels as A, B, C, D, E

# Display the final plot
print(final_plot)


