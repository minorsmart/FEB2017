require(RoogleVision)
require(googleAuthR)

### plugin your credentials
options("googleAuthR.client_id" = "225248482380-rm0qr7dssd9edfeeo0v37dpq0b5m72bf.apps.googleusercontent.com")
options("googleAuthR.client_secret" = "bVim4OgRqwQIVY4deucK2G4O")

## use the fantastic Google Auth R package
### define scope!
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))
googleAuthR::gar_auth()

############
#Basic: you can provide both, local as well as online images:
# o <- getGoogleVisionResponse("brandlogos.png")
# o <- getGoogleVisionResponse(imagePath="brandlogos.png", feature="LOGO_DETECTION", numResults=4)
getGoogleVisionResponse("blikje.jpg")
