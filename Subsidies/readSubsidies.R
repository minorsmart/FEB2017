library(dplyr)
subsidieDF2017 <- read.csv2("https://ckan.dataplatform.nl/dataset/88308fe2-9157-4204-b2f2-3d6800849e4f/resource/276d614e-58a3-4c57-9efa-5bc64819e4ec/download/subsidieregister-2017-def.csv", colClasses = "character", sep = ";")
subsidieDF2016 <- read.csv2("https://ckan.dataplatform.nl/dataset/88308fe2-9157-4204-b2f2-3d6800849e4f/resource/9ca009e4-6e77-4ceb-9376-3f06bba14946/download/subsidieregister2016-csv-versie.csv", colClasses = "character", sep = ";", skip = 2)
subsidieDF2015 <- read.csv2("https://ckan.dataplatform.nl/dataset/88308fe2-9157-4204-b2f2-3d6800849e4f/resource/82579bdf-f43a-409f-9de3-e21242ea8094/download/subsidieregister2015-csv-versie.csv", colClasses = "character", sep = ";")
subsidieDF <- rbind(subsidieDF2017, subsidieDF2016)
subsidieDF <- rbind(subsidieDF, subsidieDF2015)

subsidieDF <- mutate(subsidieDF,
                     Aangevraagd_bedrag = gsub("\x80 ", "", Aangevraagd_bedrag),
                     Aangevraagd_bedrag = gsub("\\? ", "", Aangevraagd_bedrag),
                     Aangevraagd_bedrag = gsub("\\.", "", Aangevraagd_bedrag),
                     Aangevraagd_bedrag = gsub(",", "\\.", Aangevraagd_bedrag),
                     Aangevraagd_bedrag = as.numeric(Aangevraagd_bedrag)
                     )

subsidieDF <- mutate(subsidieDF,
                     Verleend_bedrag = gsub("\x80 ", "", Verleend_bedrag),
                     Verleend_bedrag = gsub("\\? ", "", Verleend_bedrag),
                     Verleend_bedrag = gsub("\\.", "", Verleend_bedrag),
                     Verleend_bedrag = gsub(",", "\\.", Verleend_bedrag),
                     Verleend_bedrag = as.numeric(Verleend_bedrag)
)

subsidieDF <- mutate(subsidieDF,
                     Volledig_toegewezen = (Aangevraagd_bedrag == Verleend_bedrag) * 1)

summary(subsidieDF)

sum(subsidieDF$Aangevraagd_bedrag, na.rm = TRUE)
sum(subsidieDF$Verleend_bedrag, na.rm = TRUE)
sum(subsidieDF$Verleend_bedrag, na.rm = TRUE)/sum(subsidieDF$Aangevraagd_bedrag, na.rm = TRUE)
