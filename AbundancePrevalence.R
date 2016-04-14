
library(plyr)
library(dplyr)

##Set the working directory
setwd("/scicomp/home/ymg2/R/RworkingDirectory")

file.names <- dir(path = "./RuskWiz16S/", pattern =".tsv")

setwd("/scicomp/home/ymg2/R/RworkingDirectory/RuskWiz16S/")

##Loop through all files in file.names, importing them and selecting only V21, the genus counts
for(i in 1:length(file.names)){
  ##Read in dataset. Replace filepath with your filepath
  BCtemp <- read.delim(file.names[i], header = FALSE)
  ##Remove all columns but Genus names column
  BCtemp2 <- dplyr::select(BCtemp, V21)
  assign(paste("BCcounted", i, sep =""), plyr::count(BCtemp2, "V21"))
##If you want to write out the counts to .txt tsv
#  output <- plyr::count(BCtemp2, "V21")
#  write.table(output, file = paste("BC", i, sep = ""), sep = "\t")
}

##I had a lot of difficult figuring out how to make a master data frame from all of the individual tick counts
#I ended up iterating through a pairwise merge, which was labor intensive and required changing variabe names
#during each iteration. There should be an easier way to do this, but here's two iterations of what I did
#Master <- merge(x = BCcounted1, y = BCcounted2, by = "V21", all = TRUE)
#Master <- merge(x = Master, y = <next BCcounted file>, by = "V21", all = TRUE)

#count NAs
#Master_2 <- transform(Master_1, NAs = rowSums(is.na(Master_1)))

#rowMeans
#Master_1 <- transform(it24, means = rowMeans(it24[,-1], na.rm = TRUE))


##Poorly formatted generation of the plots for Division Seminar 2016
p <- ggplot(Master_2, aes(25-NAs, means, label = Master_2$V21)
p2 <- p + geom_point() + geom_text(aes(label = ifelse(NAs < 15, as.character(Master_2$V21), '')), vjust = 0, nudge_y = 0.05, fontface = "bold", size = 5)
p3 <- p2 + labs(title = expression(paste("Genus Distributions in ", italic("A. maculatum"), " Microbiomes")), x = "Number of Ticks with Genus", y = "Mean Abundane When Present") + theme(axis.title = element_text(size = 14), plot.title = element_text(size = 16))

#BCmerged <- rbind(BCcounted1, BCcounted10, BCcounted11, BCcounted12, BCcounted13, BCcounted14, BCcounted15, BCcounted16, BCcounted17, BCcounted18, BCcounted19, BCcounted2, BCcounted20, BCcounted21, BCcounted22, BCcounted23, BCcounted24, BCcounted25, BCcounted3, BCcounted4, BCcounted5, BCcounted6, BCcounted7, BCcounted8, BCcounted9)
#dflist <- c("BCcounted1", "BCcounted10", "BCcounted11", "BCcounted12", "BCcounted13", "BCcounted14", "BCcounted15", "BCcounted16", "BCcounted17", "BCcounted18", "BCcounted19", "BCcounted2", "BCcounted20", "BCcounted21", "BCcounted22", "BCcounted23", "BCcounted24", "BCcounted25", "BCcounted3", "BCcounted4", "BCcounted5", "BCcounted6", "BCcounted7", "BCcounted8", "BCcounted9")
#dflist <- list(BCcounted1, BCcounted10, BCcounted11, BCcounted12, BCcounted13, BCcounted14, BCcounted15, BCcounted16, BCcounted17, BCcounted18, BCcounted19, BCcounted2, BCcounted20, BCcounted21, BCcounted22, BCcounted23, BCcounted24, BCcounted25, BCcounted3, BCcounted4, BCcounted5, BCcounted6, BCcounted7, BCcounted8, BCcounted9)
