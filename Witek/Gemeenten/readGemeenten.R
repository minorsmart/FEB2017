library(rgdal)
library(ggplot2)
library(ggmap)
library(broom)

## De data is online beschikbaar. O.a. hier: https://data.overheid.nl/data/dataset/grenzen-van-alle-nederlandse-gemeenten-en-provincies/resource/d5570855-ceb7-458b-ba93-61e5ec332649

gemeentenShp <- readOGR(".","gemeenten")

gemeentenShp <- spTransform(gemeentenShp, CRS("+proj=longlat +datum=WGS84"))


gemeentenDF <- tidy(gemeentenShp)


nl<-get_map("Netherlands",zoom=8)
nl <- ggmap(nl) +
  geom_polygon(aes(x=long,
                   y=lat,
                   group=group),
               fill='grey',
               size=.2,
               color='green',
               data=gemeentenDF,
               alpha=0)
nl

gemeentenMeta <- gemeentenShp@data
gemeentenMeta$ID <- row.names(gemeentenMeta)
gemeentenDF <- merge(gemeentenDF, gemeentenMeta, by.x = 'id', by.y = 'ID')
cnames <- aggregate(cbind(long, lat) ~ GEMEENTENA, data=gemeentenDF, FUN=mean)

nl <- nl + geom_text(data=cnames, aes(long, lat, label = GEMEENTENA), size=2)
nl