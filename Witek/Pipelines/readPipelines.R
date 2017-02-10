library(googleVis)
library(dplyr)

pipelineDF <- read.csv("database.csv")

pipelineDF <- mutate(pipelineDF,
                     LatLong = paste0(Accident.Latitude,":", Accident.Longitude),
                     Fire = as.numeric(Liquid.Ignition) + as.numeric(Liquid.Explosion)
                     )

pipelinesMap <- gvisGeoChart(pipelineDF, 'LatLong', 
                          sizevar='All.Costs',
                          colorvar='Fire',
                          options=list( region="US",
                                        width = 1000, heigth = 800,
                                        colorAxis="{colors:[\'yellow',\'red']}"
                                        )
                          )
plot(pipelinesMap)


