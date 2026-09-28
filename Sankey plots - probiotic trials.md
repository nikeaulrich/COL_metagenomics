```
#Sankey plots for Probiotic trial samples

setwd("~/OneDrive - UMass Lowell/COL_files/cordap/field_trials_data")

#install.packages("dplyr")
#install.packages("tidyverse")
#install.packages("ggplot2")
#install.packages("devtools")
#devtools::install_github("davidsjoberg/ggsankey")

library(dplyr)
library(tidyverse)
library(ggplot2)
library(ggsankey)


colony_cond <- read.csv("ColonyData082526.csv")
treatment_list <- levels(as.factor(colony_cond$Treatment_Group))

#verify columns
colnames(colony_cond)

#code
sankeydf <- data.frame()
for(current_Treatment in treatment_list) {
  Spec_df <- colony_cond %>% 
    subset(Treatment_Group == current_Treatment) 
  sankdf <- Spec_df %>% 
    make_long(March_Day1, March_Day5, April_Day42, June_Day84, July_Day119) %>%
    mutate("Treatment" = current_Treatment) 
  sankeydf <- sankeydf %>%
    bind_rows(sankdf)
}
head(sankeydf)
write.csv(sankeydf, "sankeydf_check2.csv")

condition_list_sankey<-unique(sankeydf$node)
condition_list_sankey

#reorder condition order
sankeydf$node <- factor(sankeydf$node, 
                        levels = c("Healthy", "Disease", "YBD","Not_found"))

#colors to match the sankey plot figure from Belize that Sarah gave me
sank_colors <- c('seagreen','coral3','gold', 'grey')
barplot(rep(1, length(sank_colors)), col = sank_colors, border = NA, main = "Color Palette")

sankey <- ggplot(sankeydf, aes(x = x, 
                               next_x = next_x, 
                               node = node, 
                               next_node = next_node,
                               fill = factor(node))) +
  facet_wrap(~Treatment, as.table = FALSE) +
  geom_sankey(flow.alpha = 0.6, node.color = 'black', flow.color = 'black') +
  geom_sankey_label(
    aes(
      x = as.numeric(x) - 0.2,
      label = after_stat(freq)),
    size = 7 / .pt, color = "black", fill = "white") +  
  scale_fill_manual("Condition", values = c(sank_colors)) +
  theme(plot.title = element_text(size = 12,hjust = 0.5),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line.x = element_line(colour = "black"),
        strip.text = element_text(size = 13),
        axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        axis.text.x = element_text(colour = "black", angle = 45, hjust = 1, size = 12),
        axis.text = element_text(colour = "black"),
        axis.title.x = element_blank(),
        legend.position.inside = c(0.6,0.95),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12))
sankey

ggsave(filename = "Probiotic_trials_sankey.png", plot = sankey, 
       width = 12,
       height = 8,
       units = "in",
       dpi = 300)

dev.off()
```