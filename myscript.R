
#Written by Manoela Morais and Ajinkya Datalkar
#Upated: January 11 2022, 7:00 PM PST
install.packages("nasapower")
install.packages("forecast")
install.packages("jsonlite")

#Libraries
library(nasapower) 
library(forecast)
library(jsonlite)

setwd("~/Documents/")## <---replace working directory or erase

## annual weather forecast generation section begins ##
c<-Sys.Date()
a<-c-7
b<- as.character(a)

Country<-"India"
Province<-"Maharashtra"


cities<- array(c("Mumbai", "Pune","Nagpur"))


geoPointsLat<- array(c(19.0760, 18.5204,21.1458))

geoPointsLon<- array(c(72.8777, 73.8567,79.0882))

cityCodes <- c()
powers <- c(c())


temperature_ts_all <- c(c())
temperature_fcast_all <- c(c())
tempMax <- c(c())
tempMin <- c(c())
tempMedian <- c(c())

rainfall_ts_all <- c(c())
rainfall_fcast_all <- c(c())
rainfall_fcast_def <- c(c())
rained_yN_all <- c(c())
precipitation <- c(c())
latitudeRounding <-c(c())

weatherIcons <- c(c())

allPredictions <- c(c())

i=1
while(i <= length(cities)) {
  cityCodes[i] = paste("M",i,sep="",collapse = NULL)
  i = i + 1
}

getPowerRecursively <- function(x) {
  print(geoPointsLon[x])
  print(geoPointsLat[x])
  tryCatch({
    get_power(
      community = "ag",
      lonlat = c(geoPointsLon[x], geoPointsLat[x]),
      pars = c("T2M", "T2M_MAX", "T2M_MIN","PRECTOTCORR"),
      dates = c("2015-01-01", b),
      temporal_api = "daily"
    )
  }, error = function(e){
    Sys.sleep(50)
    print("retrying...")
    getPowerRecursively(x)
  }
  )
}

powerSequence <- seq(1, length(cities))
powers <- lapply(powerSequence,getPowerRecursively)

i=1
while(i <= length(cities)) {
  temperature_ts_all[[i]] = ts(powers[[i]],frequency=365,start=c(2015))# returns array
  temperature_fcast_all[[i]] = forecast(temperature_ts_all[[i]], h = 365)# returns array
  
  
  tempMax[[i]] = temperature_fcast_all[[i]]$forecast$T2M_MAX$mean# returns array
  tempMin[[i]] = temperature_fcast_all[[i]]$forecast$T2M_MIN$mean# returns array
  tempMedian[[i]] = temperature_fcast_all[[i]]$forecast$T2M$mean# returns array
  
  rainfall_ts_all[[i]] = ts(powers[[i]]$PRECTOTCORR,frequency=365, start=c(2015))# returns array
  rainfall_fcast_all[[i]] = snaive(rainfall_ts_all[[i]],frequency=365)# returns array
  rainfall_fcast_def[[i]] = forecast(rainfall_fcast_all[[i]], h=365)# returns array
  rained_yN_all[[i]] = ifelse(rainfall_fcast_def[[i]]$mean>= 0.001, "Yes", "No")
  
  weatherIcons[[i]] = ifelse(rainfall_fcast_def[[i]]$mean <0.001, "Absent",
                             ifelse(rainfall_fcast_def[[i]]$mean <= 0.5, "low",
                                    ifelse(rainfall_fcast_def[[i]]$mean <=4, "moderate",
                                           ifelse(rainfall_fcast_def[[i]]$mean<= 8, "high",
                                                  ifelse(rainfall_fcast_def[[i]]$mean > 8, "veryhigh",
                                                         "something is wrong")))))
  
  precipitation[[i]] = ifelse(rainfall_fcast_def[[i]]$mean <0.001, " 0 mm",
                              ifelse(rainfall_fcast_def[[i]]$mean <= 0.5, "<0.5mm",
                                     ifelse(rainfall_fcast_def[[i]]$mean <=4, "0.5-4mm",
                                            ifelse(rainfall_fcast_def[[i]]$mean <= 8, "4-8 mm",
                                                   ifelse(rainfall_fcast_def[[i]]$mean > 8, " >8mm",
                                                          "NA")))))
  
  i = i + 1
}


predictionListParameters <- list()
predictionList <- list(predictionListParameters)




d=1;
while(d<=365) {
  l<-1
  predictionListParameters['id'] <- d
  predictionListParameters['Date.fcst'] <- format (a + d, format = "%Y-%m-%d")
  predictionListParameters['Country'] <- Country
  predictionListParameters['Province'] <- Province
  while(l<=length(cities)){
    predictionListParameters[paste("TEMPMAX_fcast_",cityCodes[l],sep="",collapse = NULL)] <-floor(tempMax[[l]][d])
    predictionListParameters[paste("TEMPMIN_fcast_",cityCodes[l],sep="",collapse = NULL)] <- floor(tempMin[[l]][d])
    predictionListParameters[paste("TEMPMEDIA_fcast_",cityCodes[l],sep="",collapse = NULL)] <- floor(tempMedian[[l]][d])
    predictionListParameters[paste("icon_",cityCodes[l],sep="",collapse = NULL)] <- (weatherIcons[[l]][d])
    predictionListParameters[paste("fcast_class_",cityCodes[l],sep="",collapse = NULL)] <- precipitation[[l]][d]
    predictionListParameters[paste("SNfcast_",paste(cityCodes[l],".mean",sep = "",collapse = NULL),sep="",collapse = NULL)] <-(rainfall_fcast_def[[l]]$mean[d])
    predictionListParameters[paste("rained_",paste(cityCodes[l],"_yN",sep = "",collapse = NULL),sep="",collapse = NULL)] <-rained_yN_all[[l]][d]
    l= l + 1
  }
  predictionList[[d]] <- predictionListParameters
  d = d+1
}
exportJSON <- toJSON(predictionList, pretty = TRUE,auto_unbox = TRUE, encoding="UTF-8")
write(exportJSON, "output_forecast_maharashtra_india.json")

## annual weather forecast generation section ends ##

## city list generation section begins ##
cityParameters<- list();
cityList<- list(cityParameters);

for(c in 1:length(cities)) {
  cityParameters["Position"] <- c
  cityParameters["City"] <- cities[c]
  cityParameters["Code"] <- cityCodes[c]
  cityParameters["State"] <- Province
  cityParameters["Hemisphere"] <- "N"
  cityParameters["Latitude"] <- geoPointsLat[c]
  cityParameters["Longitude"] <- geoPointsLon[c]
  median<-0
  lat <- geoPointsLat[c]
  lon <- geoPointsLon[c]
  for(j in 1:12) {
    median = ((j*5) + (j*5 - 5))/2
    if (lat < median && lat > (j*5 - 5)) {
      cityParameters["po_place"] <- (j*5 - 5)
      break;
    } 
    if (lat > median && lat < (j*5)) {
      cityParameters["po_place"] <- (j*5)
      break;
    }
  }
  cityList[[c]]<- cityParameters
}

exportJSON <- toJSON(cityList, pretty = TRUE,auto_unbox = TRUE, encoding="UTF-8")
write(exportJSON, "cities_maharashtra_india.json")
## city list generation section ends ##
