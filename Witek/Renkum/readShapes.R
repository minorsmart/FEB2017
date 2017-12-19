library(maptools)
library(ggplot2)
library(ggmap)
library(sp)
library(rgdal)


# Use maptools to read shape data en make test plot
shapes <- readShapePoly("uitvoer_shape/buurt_2014.shp")
shapesRenkum <- shapes[na.omit(shapes$GM_NAAM == "Renkum"),]
plot(shapesRenkum)
text(coordinates(shapesRenkum), labels=shapesRenkum$BU_NAAM, cex=0.6)

# Use rgdal to read shape data and build plot with data.

## Read data and transform coordinates into Google type
shapes <- readOGR("uitvoer_shape", "buurt_2014")
shapes <- spTransform(shapes, CRS("+proj=longlat +datum=WGS84"))

## Select only Renkum with test plot
shapesRenkum <- shapes[na.omit(shapes$GM_NAAM == "Renkum"),]
plot(shapesRenkum, col=shapesRenkum@data$AANT_INW)

## Change shape data into normal data frame
dfRenkum <- fortify(shapesRenkum)

## Add values form shape data to coordinate data frame and clean up
dfRenkum$id <- as.factor(dfRenkum$id)
shapesRenkum@data <- cbind(shapesRenkum@data, id = rownames(shapesRenkum@data))
dfRenkum <- merge(dfRenkum, shapesRenkum@data, by.x = "id", by.y = "id")
dfRenkum[dfRenkum == -99999999] <- NA
write.csv(dfRenkum, "Renkum.csv")

## Plot data
mapCenter <- geocode("Doorwerth")
Renkum <- get_map(c(lon=mapCenter$lon, lat=mapCenter$lat),zoom = 12)#, maptype = "terrain", source="stamen")
RenkumMap <- ggmap(Renkum)
RenkumMap <- RenkumMap +
  geom_polygon(data = dfRenkum, aes(x=long, y=lat, group=group, fill=P_65_EO_JR),
               size=.2 ,color='black', alpha=0.6) +
  scale_fill_gradient(low = "green", high = "red")
RenkumMap
