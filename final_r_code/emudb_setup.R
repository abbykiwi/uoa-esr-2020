# code to create the emuDB and add the levels 

library(emuR)
library(wrassp)

# 1. Convert TextGrids to Emu_DBs

convert_TextGridCollection(dir="/Users/abbycroot/Desktop/semaine_transcripts/poppy", dbName = "MYF", targetDir="/Users/abbycroot/Desktop/semaine_transcripts/poppy/MYF")

#need to manually add the following to the DB's .JSON file above "active buttons"
#this enables you to switch perspectives later on which should be - but is not - automatically done when converting the textgrid collection

#"restrictions": {
#       "showPerspectivesSidebar": true
#     },

#2. Check DB

path2folder= "/Users/abbycroot/Desktop/poppy_copy/MYF/MYF_emuDB"
MYF = load_emuDB(path2folder)

serve(MYF)

   #3. Add target level to DB

add_levelDefinition(emuDBhandle = MYF,
                    name = "AROUSAL",
                    type = "EVENT")

add_levelDefinition(emuDBhandle = MYF,
                    name = "VALENCE",
                    type = "EVENT")

add_levelDefinition(emuDBhandle = MYF,
                    name = "STRESS",
                    type = "EVENT")

add_levelDefinition(emuDBhandle = MYF,
                    name = "POPPY",
                    type = "EVENT")



list_levelDefinitions(MYF)

#make level definition visible in web-app

set_levelCanvasesOrder(MYF, perspectiveName = "default", order = c("ORT-MAU", "KAN-MAU", "MAU", "AROUSAL", "VALENCE", "STRESS", "POPPY"))

#set level canvases can also be done manually by adding "TARGET" to the "levelcanvases" section of the .JSON

#4. Calculate formants and make visible in web-app

#PARAMS:

fb.params= formals(wrassp::forest)


add_ssffTrackDefinition(emuDBhandle = MYF, 
                        name = "FORMANTS", 
                        onTheFlyFunctionName = "forest", 
                        onTheFlyParams = fb.params, verbose = TRUE
                        
)


add_perspective(emuDBhandle = MYF,
                name = "formants")

set_signalCanvasesOrder(emuDBhandle = MYF,
                        perspectiveName = "formants",
                        order = c("OSCI","SPEC","FORMANTS"))

set_levelCanvasesOrder(emuDBhandle = MYF, 
                       perspectiveName = "formants", 
                       order = c("ORT-MAU", "KAN-MAU", "MAU", "AROUSAL", "VALENCE", "STRESS", "POPPY"))


#5. Overlay formants on spectrogram by manually editing .JSON

# the following needs to be added to the "signalCanvases" field of the .JSON for the formants perspective not the default
# Section 9.3.3.1 of the manual for troubleshooting

"assign": [{
  "signalCanvasName": "SPEC",
  "ssffTrackName": "FORMANTS"
}],

#remove the extra formant canvas

set_signalCanvasesOrder(emuDBhandle = MYF, perspectiveName = "formants", order = c("OSCI","SPEC"))

serve(MYF)
