library(forcats)
library(ggplot2)
library(dplyr)
library(xlsx)
library(patchwork)
#http://www.sthda.com/english/wiki/ggplot2-barplots-quick-start-guide-r-software-and-data-visualization
#30.09.2025

setwd("/home/ahmed/0_data/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/graphs/R_scripts/1_db/")

df <- as.data.frame(read.csv("imngs_samples.csv", check.names = FALSE))

df$Samples = as.numeric(df$Samples) 

# Basic barplot




p1 <- ggplot(df, aes(fill = names,reorder(Species, Samples), Samples)) + geom_col(position = "dodge")+
  coord_flip() +
  xlab("Species")+
  ylab("No. of ecological niches (IMNGS database)")+
  theme(text = element_text(size=28),legend.position="none")+
  geom_text(aes(label=round(Samples, digits = 2)),hjust=-0.25,vjust=.45,size = 12)+
  ylim(0,400)



p1




df2 = data.frame(read.csv("ecology.csv"))

df2$Sample  <- factor(df2$Sample , levels = unique(df2$Sample))


custom_theme <- theme_gray() +
  theme(text = element_text(size=28),
        axis.text.x  = element_blank(),   # hide x-axis labels
        axis.ticks.x = element_blank(),legend.position="none"
  )



p2 <- ggplot(df2, aes(fill = Species, y = Prev., x = Sample)) + 
  geom_bar(position = "dodge", stat = "identity") +
  labs(y = "Prev. per niche [%]", x = "Ecological niches of CA&CM (IMNGS database)") +
  custom_theme

p2





df3 = data.frame(read.csv("human_ecology.csv"))



df3$Sample <- factor(df3$Sample, levels = rev(unique(df3$Sample)))

# Define dodge position
dodge <- position_dodge(width = 0.9)

# Plot with numbers on bars
p3 <- ggplot(df3, aes(x = Sample, y = Prev., fill = Species)) + 
  geom_bar(stat = "identity", position = dodge) +
  geom_text(aes(label = round(Prev.,2)), position = dodge, hjust = -0.1,size = 10) + # numbers outside bars
  labs(x = "Human associated niches", y = "CA and CM Prev. [%] (IMNGS database)") +
  coord_flip()+
  theme(text = element_text(size=28),legend.position="none")+
  ylim(0,75)

p3


df4 <- as.data.frame(read.csv("curated_spp_heatmap.csv", check.names = FALSE))
df4$Sample <- factor(df4$Sample, levels = rev(unique(df4$Sample)))

df4$Prev. = as.numeric(df4$Prev.) 

# Basic barplot



df5 = data.frame(read.csv("human_secretion_ecology.csv"))



df5$Sample <- factor(df5$Sample, levels = rev(unique(df5$Sample)))

# Define dodge position
dodge <- position_dodge(width = 0.9)


# Plot with numbers on bars
p5 <- ggplot(df5, aes(x = Sample, y = Prev., fill = Species)) + 
  geom_bar(stat = "identity", position = dodge) +
  geom_text(aes(label = round(Prev.,2)), position = dodge, hjust = -0.1,size = 10) + # numbers outside bars
  labs(x = "Human secretion associated niches", y = "CA Prev. [%] (IMNGS database)") +
  coord_flip()+
  theme(text = element_text(size=28),legend.position="none")+
  ylim(0,100)

p5


p4 <- ggplot(df4, aes(x = Sample, y = Prev., fill = Species)) + 
  geom_bar(stat = "identity", position = dodge) +
  geom_text(aes(label = round(Prev.,2)), position = dodge, hjust = -0.1,size = 10) + # numbers outside bars
  labs(x = "Human associated niches", y = "CA Prev. [%] (curatedMetagenomicData database)") +
  coord_flip()+
  theme(text = element_text(size=28),legend.position="none")+
  ylim(0,100)

p4




final_plot <- (p1+p2+p3+p5+p4) + 
  plot_layout(ncol = 2, nrow = 3) + 
  plot_annotation(tag_levels = 'A')  # Labels panels as A, B, C, D, E

# Display the final plot
print(final_plot)

#################################3
