##Load dplyr and ggplot2
library(dplyr)
library(ggplot2)

################################################################################
## This block of code you will have to manually alter for each group of ticks ##
## *just change the directory containing the data, then rename all variables  ##
################################################################################

##set the working directory
setwd("/scicomp/home/ymg2/R/RworkingDirectory/RuskWiz16S_sorted")

##set the directory to pull from. Change path when necessary
file.names <- dir(path = "./DogEngorgedFemale/", pattern =".tsv")

##set working directory to desired sub directory
setwd("/scicomp/home/ymg2/R/RworkingDirectory/RuskWiz16S_sorted/DogEngorgedFemale/")

##Loop through all files in file.names, importing them and selecting only V21, the genus counts
for(i in 1:length(file.names)){
  ##Read in dataset. Replace filepath with your filepath
  BCtemp <- read.delim(file.names[i], header = FALSE)
  ##Remove all columns but Genus names column
  assign(paste("BCselected", i, sep =""), select(BCtemp, V21))
}
 
##Concatenate(I couldn't figure out how to iterate through like perl: BCselected{0:length(file.names)})
BCmergedDEF <- rbind(BCselected1, BCselected2, BCselected3, BCselected4)

##Remove blank genus (These are unresolved and can be tossed for now)
BCmergedDEF <- filter(BCselected1, V21 != "")

##Tally Genus for plotting
BCcountedDEF <- plyr::count(BCmergedDEF, "V21")

##Convert counts to proportions
BCpropsDEF <- mutate(BCcountedDEF, prop = prop.table(freq))

##Sort descending on freq, cut off top 8
BCsortedDEF <- BCpropsDEF[with(BCpropsDEF, order(-freq)), ]

###################################################################
## End of block requiring manual alteration based on tick groups ##
###################################################################

##set up for plotting with facets (using facets to maintain colour of genera across charts)
BCsortedHFF$id = 'Flat Females from Human (n=3)'
BCsortedHFM$id = 'Flat Males from Human (n=7)'
BCsortedHoEF$id = 'Engorged Females from Horse (n=5)'
BCsortedHoFF$id = 'Flat Females from Horse (n=2)'
BCsortedHoFM$id = 'Flat Males from Horse (n=4)'
BCsortedDEF$id = 'Engorge Female from Dog (n=1)'

##Concatenate different groups
df_all = rbind(BCsortedDEF, BCsortedHFF, BCsortedHFM, BCsortedHoEF, BCsortedHoFF, BCsortedHoFM)

##Sort on -proportion
df_all_sorted <- df_all[with(df_all, order(-prop)), ]

##slice top 30
df_alltop10 <- slice(df_all_sorted, 1:30)

##reset column names
colnames(df_alltop10) <- c("Genera", "Frequency", "Proportion", "id")

######################################################
## Keep track of temp commands for other plots here ##
######################################################

##I used this temporary code to make a plot of just the flat males from horses
final_HoFM <- BCsortedHoFM[with(BCsortedHoFM, order(-prop)), ]
colnames(final_HoFM) <- c("Genera", "Frequency", "Proportion", "id")
final_HoFM_chop <- slice(final_HoFM, 1:15)


############################
## End temp command space ##
############################

##Plot it!
plot <- ggplot(final_HoFM_chop, aes(x=reorder(Genera, -Proportion), y=Proportion, fill=Genera)) +
  geom_bar(stat="identity") + facet_wrap(~id) + theme(axis.text.x = element_text(size=14, angle = 45, hjust = 1)) +
  theme(axis.text.y = element_text(size=14)) + labs(x = "Genera", y = "Proportion") +
  theme(axis.title = element_text(size = 14, face = "bold")) +
  theme(legend.text=element_text(size=16)) + theme(strip.text.x=element_text(size=16)) +
  theme(axis.line = element_line(colour = "black", size = 0.5))+
  theme(panel.grid.major.y = element_line(colour = "black", size = 0.3)) +
  theme(panel.grid.minor.y = element_line(colour = "black", size = 0.2)) +
  theme(legend.position = "none")

##View the plot
plot

HumanFlatFemaleChart <- ggplot(BCtop8, aes(x = reorder(V21, -freq), y=freq, fill=V21)) + geom_bar(stat = "identity") + scale_y_log10() + theme(axis.text.x = element_text(size=14, angle = 45, hjust = 1)) + labs(title = "Flat Females from Human", x = "Genera", y = "Frequency")

HumanFlatFemaleChart  

