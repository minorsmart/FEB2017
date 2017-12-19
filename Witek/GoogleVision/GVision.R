require(RoogleVision)
require(googleAuthR)
require(RCurl)

### plugin your credentials
options("googleAuthR.client_id" = "225248482380-rm0qr7dssd9edfeeo0v37dpq0b5m72bf.apps.googleusercontent.com")
options("googleAuthR.client_secret" = "bVim4OgRqwQIVY4deucK2G4O")
options("googleAuthR.key" = "AIzaSyCVJguLEJuv4tmXvxG0ICpTRdzwoOgnmXA")

## use the fantastic Google Auth R package
### define scope!
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))
googleAuthR::gar_auth()

############
#Basic: you can provide both, local as well as online images:
# o <- getGoogleVisionResponse("brandlogos.png")
# o <- getGoogleVisionResponse(imagePath="brandlogos.png", feature="LANDMARK_DETECTION", numResults=4)
getGoogleVisionResponse("blikje.jpg")
getGoogleVisionResponse("beker.jpg")

imageFile <- "snake2.png"
#imageFile <- url("dom.jpg", "rb")
txt <- base64Encode(readBin(imageFile, "raw", file.info(imageFile)[1, "size"]), "txt")

### create Request, following the API Docs.
body= paste0('{  "requests": [    {   "image": { "content": "',txt,'" }, "features": [  { "type": "lABEL_DETECTION", "maxResults": 15} ],  }    ],}')

## generate function call
simpleCall <- gar_api_generator(baseURI = "https://vision.googleapis.com/v1/images:annotate", http_header="POST" )

## set the request!
pp <- simpleCall(the_body = body)
st <- pp$content$responses[[1]][[1]]
