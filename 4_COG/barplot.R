library(forcats)
library(ggplot2)
library(dplyr)
library(xlsx)
library(patchwork)
#http://www.sthda.com/english/wiki/ggplot2-barplots-quick-start-guide-r-software-and-data-visualization

setwd("/home/ahmed/0_data/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/graphs/R_scripts/4_COG/")

df <- as.data.frame(readLines("1accolens_vs_mac_graph1.csv"))

colnames(df) <- "COG_category"
# Basic barplot
df_summary <- df %>%
  count(COG_category) %>%
  arrange(desc(n)) %>%
  mutate(COG_category = factor(COG_category, levels = COG_category))



p1 <- ggplot(df_summary, aes(reorder(COG_category, n), n)) + geom_col(position = "dodge")+
  coord_flip() +
  xlab("COG Category")+
  ylab("Frequency")+
  theme(text = element_text(size=20))+
  geom_text(aes(label=round(n, digits = 2)),hjust=-0.25,vjust=.7,size = 8)+
  ylim(0,15)



p1

df2 <- as.data.frame(readLines("2cai_only.csv"))
colnames(df2) <- "COG_category"

df_summary2 <- df2 %>%
  count(COG_category) %>%
  arrange(desc(n)) %>%
  mutate(COG_category = factor(COG_category, levels = COG_category))



p2 <- ggplot(df_summary2, aes(reorder(COG_category, n), n)) + geom_col(position = "dodge")+
  coord_flip() +
  xlab("COG Category")+
  ylab("Frequency")+
  theme(text = element_text(size=14))+
  geom_text(aes(label=round(n, digits = 2)),hjust=-0.25 ,vjust=.7,size = 10)+
  ylim(0,14)


p2

df3 <- as.data.frame(readLines("3mac_vs_acc.csv"))

colnames(df3) <- "COG_category"

df_summary3 <- df3 %>%
  count(COG_category) %>%
  arrange(desc(n)) %>%
  mutate(COG_category = factor(COG_category, levels = COG_category))

p3 <- ggplot(df_summary3, aes(reorder(COG_category, n), n)) + geom_col(position = "dodge")+
  coord_flip() +
  xlab("COG Category")+
  ylab("Frequency")+
  theme(text = element_text(size=20))+
  geom_text(aes(label=round(n, digits = 2)),hjust=-0.25, vjust=.45,size = 8)+
  ylim(0,6)


p3

final_plot <- (p1+p3) + 
  plot_layout(ncol = 3, nrow = 1) + 
  plot_annotation(tag_levels = 'A')  # Labels panels as A, B, C, D, E

# Display the final plot
print(final_plot)