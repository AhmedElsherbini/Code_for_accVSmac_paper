rm(list = ls())

#setup and load----
library("ggplot2")
library(RColorBrewer)
library(Rmisc)
library(nlme)
library(scales)
library(readxl)
library(ggforce)
library(plyr)
library(tidyr)
library(scales)
library(broom)
library(ggpubr)
library(drc)
library(shadowtext)
library(purrr)
library(colorspace)
library(ggbreak)
library(ggpubr)
library(cowplot)


# Load dd
setwd("/home/ahmed/0_data/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/34_c.accolens_ko/")
data_cheating <- read_excel("cheating_assay_masterfile.xlsx")

head(data_cheating)

# Change bio_rep, tec_rep to character
data_cheating$bio_rep <- as.character(data_cheating$bio_rep)
data_cheating$tec_rep <- as.character(data_cheating$tec_rep)

# New column with Rasiusmm (radius in mm)
data_cheating$Radiusmm <- data_cheating$Radiusum/1000

head(data_cheating)

# Remove contaminated spots
data_cheating <- data_cheating[data_cheating$cont=='no',]

# Plot Radus of cheating vs producer 
p_cheating_SA <- ggplot(data=data_cheating[data_cheating$Prov_species=='S. aureus',], aes(y=Radiusmm, x = Provider, fill = Isolate))+
  geom_boxplot() +
  geom_point(data = data_cheating[data_cheating$Prov_species=='S. aureus',], position=position_dodge(width = 0.75))+
  facet_grid(~Prov_species) +
  ylab('growth radius [mm]')+
  xlab('Producer') +
  ylim(0,28.5) +
  scale_fill_discrete(guide = 'none') +
  #scale_shape_discrete(name='Replicate', guide = 'none')+
  #scale_fill_discrete(name = 'Pre-conditioning', labels = c('C63', 'KPL1989', 'None')) +
  theme_bw()+
  theme(axis.title.x = element_text(size=25),
        axis.title.y = element_text(size=25),
        axis.text.y = element_text(size=20),
        axis.text.x.bottom = element_text(size=20),
        legend.text = element_text(size=20),
        legend.title = element_text(size=25),
        panel.grid = element_blank(),
        strip.text = element_text(size = 25, face = 'italic'),
        strip.background = element_rect(color="black", fill="white", size=1.5, linetype="solid")) 

p_cheating_SA

p_cheating_SE <- ggplot(data=data_cheating[data_cheating$Prov_species=='S. epidermidis',], aes(y=Radiusmm, x = Provider, fill = Isolate))+
  geom_boxplot() +
  geom_point(data = data_cheating[data_cheating$Prov_species=='S. epidermidis',], position=position_dodge(width = 0.75))+
  facet_grid(~Prov_species) +
  ylab('growth radius [mm]')+
  xlab('Producer') +
  ylim(0,23) +
  scale_fill_discrete(guide = 'none') +
  #scale_shape_discrete(name='Replicate', guide = 'none')+
  #scale_fill_discrete(name = 'Pre-conditioning', labels = c('C63', 'KPL1989', 'None')) +
  theme_bw()+
  theme(axis.title.x = element_text(size=35),
        axis.title.y = element_text(size=35),
        axis.text.y = element_text(size=30),
        axis.text.x.bottom = element_text(size=30),
        legend.text = element_text(size=30),
        legend.title = element_text(size=35),
        panel.grid = element_blank(),
        strip.text = element_text(size = 35, face = 'italic'),
        strip.background = element_rect(color="black", fill="white", size=1.5, linetype="solid")) 

p_cheating_SE

p_cheating_CP <- ggplot(data=data_cheating[data_cheating$Prov_species=='C. propinquum',], aes(y=Radiusmm, x = Provider, fill = Isolate))+
  geom_boxplot() +
  geom_point(data = data_cheating[data_cheating$Prov_species=='C. propinquum',], position=position_dodge(width = 0.75))+
  facet_grid(~Prov_species) +
  ylab('growth radius [mm]')+
  xlab('Producer') +
  ylim(0,28.5) +
  scale_fill_discrete(guide = 'none') +
  #scale_shape_discrete(name='Replicate', guide = 'none')+
  #scale_fill_discrete(name = 'Pre-conditioning', labels = c('C63', 'KPL1989', 'None')) +
  theme_bw()+
  theme(axis.title.x = element_text(size=25),
        axis.title.y = element_text(size=25),
        axis.text.y = element_text(size=20),
        axis.text.x.bottom = element_text(size=20),
        legend.text = element_text(size=20),
        legend.title = element_text(size=25),
        panel.grid = element_blank(),
        strip.text = element_text(size = 25, face = 'italic'),
        strip.background = element_rect(color="black", fill="white", size=1.5, linetype="solid")) 

p_cheating_CP

p_cheating_EC <- ggplot(data=data_cheating[data_cheating$Prov_species=='E. coli',], aes(y=Radiusmm, x = Provider, fill = Isolate))+
  geom_boxplot() +
  geom_point(data = data_cheating[data_cheating$Prov_species=='E. coli',], position=position_dodge(width = 0.75))+
  facet_grid(~Prov_species) +
  ylab('growth radius [mm]')+
  xlab('Producer') +
  ylim(0,28.5) +
  #scale_shape_discrete(name='Replicate', guide = 'none')+
  #scale_fill_discrete(name = 'Pre-conditioning', labels = c('C63', 'KPL1989', 'None')) +
  theme_bw()+
  theme(axis.title.x = element_text(size=25),
        axis.title.y = element_text(size=25),
        axis.text.y = element_text(size=20),
        axis.text.x.bottom = element_text(size=20),
        legend.text = element_text(size=20),
        legend.title = element_text(size=25),
        panel.grid = element_blank(),
        strip.text = element_text(size = 25, face = 'italic'),
        strip.background = element_rect(color="black", fill="white", size=1.5, linetype="solid")) 

p_cheating_EC

ggarrange(p_cheating_SA, p_cheating_CP, p_cheating_EC, nrow = 1, common.legend = TRUE, legend = 'bottom')


