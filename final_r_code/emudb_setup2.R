######### build hierarchies ##########
library(emuR)

# add the hierarchies/links between all the layers - valence/arousal/stress
path2folder = "/Users/abbycroot/Desktop/semaine_transcripts/poppy/MYF/MYF_emuDB"
MYF= load_emuDB(path2folder)	

add_linkDefinition(MYF, type = "ONE_TO_MANY",
                   superlevelName = "ORT-MAU",
                   sublevelName = "MAU")

add_linkDefinition(MYF, type = "ONE_TO_MANY",
                   superlevelName = "MAU",
                   sublevelName = "AROUSAL")

add_linkDefinition(MYF, type = "ONE_TO_MANY",
                   superlevelName = "MAU",
                   sublevelName = "VALENCE")

add_linkDefinition(MYF, type = "ONE_TO_MANY",
                   superlevelName = "ORT-MAU",
                   sublevelName = "STRESS")

add_linkDefinition(MYF, type = "ONE_TO_MANY",
                   superlevelName = "ORT-MAU",
                   sublevelName = "STRESS")

autobuild_linkFromTimes(MYF,
                        superlevelName = "ORT-MAU",
                        sublevelName = "MAU",
                        convertSuperlevel = FALSE,
                        verbose = TRUE)

autobuild_linkFromTimes(MYF,
                        superlevelName = "MAU",
                        sublevelName = "AROUSAL",
                        convertSuperlevel = FALSE,
                        verbose = TRUE)

autobuild_linkFromTimes(MYF,
                        superlevelName = "MAU",
                        sublevelName = "VALENCE",
                        convertSuperlevel = FALSE,
                        verbose = TRUE)

autobuild_linkFromTimes(MYF,
                        superlevelName = "ORT-MAU",
                        sublevelName = "STRESS",
                        convertSuperlevel = FALSE,
                        verbose = TRUE)

serve(MYF)

########TROUBLESHOOTING IF SOMETHING GOES WRONG###########


remove_linkDefinition(MYF,
                      superlevelName = "ORT-MAU",
                      sublevelName = "MAU", force=T)

remove_linkDefinition(MYF,
                      superlevelName = "MAU",
                      sublevelName = "TARGET", force=T)

remove_attrDefLabelGroup(MYF,
                         levelName = 'MAU', 
                         attributeDefinitionName = 'MAU',
                         labelGroupName = 'mono')

remove_attrDefLabelGroup(MYF,
                         levelName = 'MAU', 
                         attributeDefinitionName = 'MAU',
                         labelGroupName = 'diph')
