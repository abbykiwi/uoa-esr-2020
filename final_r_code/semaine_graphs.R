#Reading valence and arousal marked database

library(emuR)
library(ggplot2)
library(ggforce)
library(magrittr)
library(patchwork)

# create path to database
path2ae = "/Users/abbycroot/Desktop/poppy_copy/MYF/MYF_emuDB"

# load database
# (verbose = F is only set to avoid additional output in manual)
ae = load_emuDB(path2ae, verbose = F)
serve(ae)

# code to generate the csv file for the SEMAINE database annotations
semaine_arousal = query(ae, "[AROUSAL =~ .*  ^ MAU =~ .* ]")
semaine_valence = query(ae, "[VALENCE =~ .*  ^ MAU =~ .* ]")

write.csv(semaine_arousal, "semaine_arousalv2.csv")
write.csv(semaine_valence, "semaine_valencev2.csv")

# load the csv file with both valence and arousal
semaine_csv <- read.csv("semaine_validation_annotation_data.csv")


## LINE PLOTS ##

#create the line plot with the formatting and save the image file
timegraph1 <- semaine_csv %>% ggplot(aes(time, valence)) + geom_line(col='black') + labs(title="Validation Annotation - Done at UoA (2020) - Valence") + theme(plot.title = element_text(face="bold.italic", size=15), 
                                                                                                                    text = element_text(size=15), panel.grid.major = element_blank(), 
                                                                                                                    panel.grid.minor = element_blank(), panel.background = element_blank(), 
                                                                                                                    axis.line = element_line(colour = "black"))


timegraph1 %+% scale_y_continuous(name="Valence", limits=c(-1, 1)) + scale_x_continuous(name="Time (s)")

ggsave(paste("validation-valence", ".png", sep=""), width=7, height=7, units="in")


# create the line plot for the the semaine annotations data

semaine_csv <- read.csv("semaine_comparison_data.csv")

timegraph2 <- semaine_csv %>% ggplot(aes(time, arousal)) + geom_line() + geom_smooth() + labs(title="Semaine Annotation 8 (from the database) - Arousal") + theme(plot.title = element_text(face="bold.italic", size=15), 
                                                                                                       text = element_text(size=15), panel.grid.major = element_blank(), 
                                                                                                       panel.grid.minor = element_blank(), panel.background = element_blank(), 
                                                                                                       axis.line = element_line(colour = "black"))


timegraph2 %+% scale_y_continuous(name="Arousal", limits=c(-1, 1)) + scale_x_continuous(name="Time (s)")


ggsave(paste("semaine_arousal8", ".png", sep=""), width=7, height=7, units="in")


#plots both line plots side by side 
timegraph1 + timegraph2 

#generate one line graph on top of the other

semaine_csv <- read.csv("semaine_comparison_data.csv")
valid_csv <- read.csv("semaine_validation_annotation_data.csv")


timegraph2 <- ggplot(semaine_csv, aes(time, valence)) + geom_line() + geom_line(data=valid_csv, col="red3") + labs(title="Valence - Average Semaine Annotation (from the database - black) vs. Validation Annotation (UoA, 2020 - red)") + theme(plot.title = element_text(face="bold.italic", size=15), 
                                                                                                                                                                  text = element_text(size=15), panel.grid.major = element_blank(), 
                                                                                                                                                                  panel.grid.minor = element_blank(), panel.background = element_blank(), 
                                                                                                                                                                  axis.line = element_line(colour = "black"))


timegraph2 %+% scale_y_continuous(name="Valence", limits=c(-1, 1)) + scale_x_continuous(name="Time (s)")


ggsave(paste("both_valence", ".png", sep=""), width=7, height=7, units="in")


## CIRCLE PLOTS ##

#make the circle plot representation of the annotations (x/y axis for valence/arousal)

#loads the required files
semaine_csv <- read.csv("semaine_comparison_data.csv")
semaine_csv <- read.csv("semaine_validation_annotation_data.csv")

#generates the graph with the valence and arousal points marked (and required formatting)
circle_graph <- semaine_csv %>% ggplot(aes(valence, arousal)) + geom_point() 

circle_graph_complete <- circle_graph + labs(title='Average Semaine Annotation (from database) - Valence-Arousal Plot') + theme(plot.title = element_text(face="bold.italic", size=15), 
                                                                                 text = element_text(size=15), panel.grid.major = element_blank(), 
                                                                                 panel.grid.minor = element_blank(), panel.background = element_blank(), 
                                                                                 axis.line = element_line(colour = "black")) + scale_x_continuous(name="Valence", limits=c(-1, 1)) + scale_y_continuous(name="Arousal", limits=c(-1, 1))

#add the circle around the outside of the graph and the axis lines to the middle of the graph
circle_graph_complete <- circle_graph_complete + geom_hline(yintercept=0) + geom_vline(xintercept=0) + geom_mark_circle(aes(x = 0, y = 0), radius=0.5, colour="black") + geom_point()
circle_graph_complete


#create circle plot with overlay of validation (my) annotations and the semaine annotations
#load the data
valid_csv <- read.csv("semaine_validation_annotation_data.csv")
semaine_csv <- read.csv("semaine_comparison_data.csv")

# generate the graph with formatting
circle_graph2 <- ggplot(semaine_csv, aes(valence, arousal)) + geom_point() + geom_point(data=valid_csv, col='tomato2')

circle_graph_complete2 <- circle_graph2 + labs(title='Average Semaine Annotation (from database - black) vs Validation Annotation (UoA, 2020 - red)') + theme(plot.title = element_text(face="bold.italic", size=15), 
                                                                                                      text = element_text(size=15), panel.grid.major = element_blank(), 
                                                                                                      panel.grid.minor = element_blank(), panel.background = element_blank(), 
                                                                                                      axis.line = element_line(colour = "black")) + scale_x_continuous(name="Valence", limits=c(-1, 1)) + scale_y_continuous(name="Arousal", limits=c(-1, 1))

#add the circle around the outside of the graph and the axis lines to the middle of the graph
circle_graph_complete2 <- circle_graph_complete2 + geom_hline(yintercept=0) + geom_vline(xintercept=0) + geom_mark_circle(aes(x = 0, y = 0), radius=0.5, colour="black") + geom_point()
circle_graph_complete2

# when downloading/exporting the image file of the circle plots, the size should be approx 1100x1000 to make sure the circle is sized properly

setwd("/Users/abbycroot/Desktop")
