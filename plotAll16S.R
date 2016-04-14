###This script parses data from Geneious 16S tool to make plots

##Set the working directory
setwd("/scicomp/home/ymg2/R/RworkingDirectory")

##Install packages plyr, dplyr, ggplot2, and gridExtra. Only necessary if not previously installed. Remove '#' below to use.
#install.packages("plyr")
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("gridExtra")

##Load plyr, dplyr, and ggplot2 (important to load plyr before dplyr)
library(plyr)
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)

file.names <- dir(path = "./RuskWiz16S/", pattern =".tsv")

setwd("/scicomp/home/ymg2/R/RworkingDirectory/RuskWiz16S/")

for (i in 1:4){
#for(i in 1:length(file.names)){
##Read in dataset. Replace filepath with your filepath
  BC1 <- read.delim(file.names[i], header = FALSE)
##Remove all columns but Genus names column
  BC1filt <- select(BC1, V21)
##Tally Genus for plotting
  bc1fCounts <- plyr::count(BC1filt, "V21")
##Sort descending on freq, cut off top 8
  bc1fSorted <- bc1fCounts[with(bc1fCounts, order(-freq)), ]
  bc1f8 <- slice(bc1fSorted, 1:8)
##Create ggplot object using Genus column, then view it while applying bargraph geometry
  plt <- ggplot(bc1f8, aes(x = reorder(V21, -freq), y=freq)) + geom_bar(stat = "identity") + scale_y_log10() + theme(axis.text.x = element_text(size=14, angle = 45, hjust = 1)) + labs(title = file.names[i], x = "Genera", y = "Frequency")
  
  nam <- paste("plt", i, sep = "_")
  assign(nam, plt)
}

allgraphs <- grid.arrange(plt_1, plt_2, plt_3, plt_4, ncol = 2)
#allgraphs <- grid.arrange(plt_1, plt_2, plt_3, plt_4, plt_5, plt_6, plt_7, plt_8, plt_9, plt_10, plt_11, plt_12, plt_13, plt_14, plt_15, plt_16, plt_17, plt_18, plt_19, plt_20, plt_21, plt_22, plt_23, plt_24, plt_25, ncol = 5, top = "Title")
allgraphs
