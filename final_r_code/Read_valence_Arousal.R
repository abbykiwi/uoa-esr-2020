#Reading valence and arousal from the marked database

library(emuR)
library(ggplot2)
library(ggforce)

# create path to demo database
path2ae = "/Users/abbycroot/Desktop/poppy_copy/MYF/MYF_emuDB"

# load database
# (verbose = F is only set to avoid additional output in manual)
ae = load_emuDB(path2ae, verbose = F)
serve(ae)


# query the database to obtain the data for the arousal and valence levels for each speaker
f1_arousal = query(ae, "[AROUSAL =~ .*  ^ MAU =~ .* ]")
f1_valence = query(ae, "[VALENCE =~ .*  ^ MAU =~ .* ]")

m2_arousal = query(ae, "[AROUSAL =~ .*  ^ MAU =~ .* ]")
m2_valence = query(ae, "[VALENCE =~ .*  ^ MAU =~ .* ]")

m1_arousal = query(ae, "[AROUSAL =~ .*  ^ MAU =~ .* ]")
m1_valence = query(ae, "[VALENCE =~ .*  ^ MAU =~ .* ]")

f2_arousal = query(ae, "[AROUSAL =~ .*  ^ MAU =~ .* ]")
f2_valence = query(ae, "[VALENCE =~ .*  ^ MAU =~ .* ]")

#write the dataframe to a csv file - one file for each speaker/ per valence and arousal

write.csv(m1_arousal, "male1_arousalv2.csv")
write.csv(m1_valence, "male1_valencev2.csv")

write.csv(m2_arousal, "male2_arousalv2.csv")
write.csv(m2_valence, "male2_valencev2.csv")

write.csv(f2_arousal, "female2_arousalv2.csv")
write.csv(f2_valence, "female2_valencev2.csv")

f1_combined <- read.csv("female1_arousal_valence_v2.csv")
m2_combined <- read.csv("male2_arousal_valence_v2.csv")
m1_combined <- read.csv("male1_arousal_valence_v2.csv")
f2_combined <- read.csv("female2_arousal_valence_v2.csv")

#create a csv file with all the speakers (combines the csv files from all the speakers) - write to total.csv

total_combined <- rbind(f1_combined, m2_combined, m1_combined, f2_combined)

write.csv(total_combined, "total.csv")

# load the csv file with all the speakers
arousal_csv <- read.csv('total.csv')


## CIRCLE PLOT ##

#generate the graph with the valence and arousal points marked 
f1_graph <- arousal_csv %>% ggplot(aes(x = valence, y = arousal, colour = emotion)) + geom_point() 

f1_graph_complete <- f1_graph + labs(title='Male1 Valence-Arousal Plot') + theme(plot.title = element_text(face="bold.italic", size=15), 
                                                                                   text = element_text(size=15), panel.grid.major = element_blank(), 
                                                                                   panel.grid.minor = element_blank(), panel.background = element_blank(), 
                                                                                   axis.line = element_line(colour = "black")) + scale_x_continuous(name="Valence", limits=c(-1, 1)) + scale_y_continuous(name="Arousal", limits=c(-1, 1))

#add the circle around the outside of the graph and the axis lines to the middle of the graph
f1_graph_complete <- f1_graph_complete + geom_hline(yintercept=0) + geom_vline(xintercept=0) + geom_mark_circle(aes(x = 0, y = 0), radius=0.5, colour="black") + geom_point()
f1_graph_complete %+% subset(arousal_csv, bundle.1 %in% c("male1"))

# when downloading/exporting the image file of the circle plots, the size should be approx 1100x1000 to make sure the circle is sized properly


## LINE PLOT ##

#generating the plot that marks the valence and arousal based on time - one per sentence per speaker

for (x in 1:15){
  string <- paste('Male1 Sentence', toString(x), '- Valence vs Time')
  number <- paste(x, "a", sep="")
  timegraph <- arousal_csv %>% ggplot(aes(start, valence, colour=emotion)) + geom_line() + labs(title=string) + theme(plot.title = element_text(face="bold.italic", size=15), 
                                                                                                                                                                 text = element_text(size=15), panel.grid.major = element_blank(), 
                                                                                                                                                                 panel.grid.minor = element_blank(), panel.background = element_blank(), 
                                                                                                                                                                 axis.line = element_line(colour = "black"))
  
  timegraph %+% subset(arousal_csv, num1 %in% c(number) & bundle.1 %in% c("male1")) + scale_y_continuous(name="Arousal", limits=c(-1, 1)) + scale_x_continuous(name="Time (ms)")
  
  ggsave(paste(string, ".png", sep=""), width=13.4, height=13.1, units="in")
}



