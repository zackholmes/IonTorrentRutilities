###This script parses data from Geneious 16S tool for quick analysis

##Set the working directory
setwd("/scicomp/home/ymg2/R/RworkingDirectory")

##Install packages plyr, dplyr, and ggplot2. Only necessary if not previously installed. Remove '#' below to use.
#install.packages("plyr")
#install.packages("dplyr")
#install.packages("ggplot2")

##Load plyr, dplyr, and ggplot2 (important to load plyr before dplyr)
library(plyr)
library(dplyr)
library(ggplot2)

##Read in dataset. Replace filepath with your filepath
BC1 <- read.delim("RuskWiz16S//16S-Biodiversity-results_BC1.tsv", header = FALSE)

##Look at first 6 rows to visually inspect data
head(BC1)

##Remove unnecessary data columns to speed processing
BC1filt <- select(BC1, -V2, -V3, -V4, -V5, -V7, -V10, -V13, -V16, -V19, -V22)

##Set column names
colnames(BC1filt) <- c("read_ID", "Domain", "domainScore", "Phylum", "phylumScore", "Class", "classScore", "Order", "orderScore", "Family", "familyScore", "Genus", "genusScore")

##On import, R chops off columns on rows with "sub" taxonimic groups. Get rid of the extra rows (data isn't lost)
bc1f <- filter(BC1filt, read_ID != "Corynebacteriaceae")
bc1f <- filter(bc1f, read_ID != "Dietziaceae")

##View a quick summary of data
summary(bc1f)

##Tally Genus for plotting
bc1fCounts <- plyr::count(bc1f, "Genus")

##Sort descending on freq
bc1fSorted <- bc1fCounts[with(bc1fCounts, order(-freq)), ]
bc1f8 <- slice(bc1fSorted, 1:8)

##Create ggplot object using Genus column, then view it while applying bargraph geometry
ggplot(bc1f8, aes(x = reorder(Genus, -freq), y=freq)) + 
  geom_bar(stat = "identity") + 
  scale_y_log10() + 
  theme(axis.text.x = element_text(size=14, angle = 45, hjust = 1))
