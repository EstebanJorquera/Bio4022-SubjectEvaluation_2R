###Run whole script before working with either markdown files
#Sets up the global environment used by those files
#done, mainly, to speed up the process

###load libraries
library(tidyverse)#base library
library(dismo)#gets animal observation data
library(knitr)#graphic tools for Rmarkdown (allows kable)
library(kableExtra)#extra tools for kable
library(leaflet)#graphic tools for maps
library(rgbif)#search tools for gbif

###Values
#date info of when was the data collected
curr_Year <- format(Sys.Date(), "%Y")
curr_Month <- format(Sys.Date(), "%m")
curr_Day <- format(Sys.Date(), "%d")

#observation limit to download
occ_Limit <- 100000 #less than 101000; 5000 is good for testing

###GBIF data
#gets data of all species within Delphinidae

Delphinidae <- name_suggest(
  q = "Delphinidae",
  rank = "family"
)

#gets the number of Delphinidae observations, under filter conditions since the limit is 250000; which will indicate an error but not report it to you, also trying to keep the number below 101000 items to download, mainly due to GBIF download limits, and time...
#tries a period of 10 years from the current year, if the number of observations is over the limit, it tries a period of 9 years and tries again, until it only tries for the last 5 years,

Delphinidae_count <- occ_search(
  taxonKey = Delphinidae$key,
  hasCoordinate = TRUE,
  basisOfRecord = "HUMAN_OBSERVATION",
  year = (paste(as.double(curr_Year)-9,",",curr_Year)),
  return = "meta"
)$count
year_from <- as.double(curr_Year)-9
year_to <- curr_Year

if(Delphinidae_count >= occ_Limit){
  Delphinidae_count <- occ_search(
    taxonKey = Delphinidae$key,
    hasCoordinate = TRUE,
    basisOfRecord = "HUMAN_OBSERVATION",
    year = (paste(as.double(curr_Year)-8,",",curr_Year)),
    return = "meta"
  )$count
  year_from <- as.double(curr_Year)-8
  
  if(Delphinidae_count >= occ_Limit){
    Delphinidae_count <- occ_search(
      taxonKey = Delphinidae$key,
      hasCoordinate = TRUE,
      basisOfRecord = "HUMAN_OBSERVATION",
      year = (paste(as.double(curr_Year)-7,",",curr_Year)),
      return = "meta"
    )$count
    year_from <- as.double(curr_Year)-7
    
    if(Delphinidae_count >= occ_Limit){
      Delphinidae_count <- occ_search(
        taxonKey = Delphinidae$key,
        hasCoordinate = TRUE,
        basisOfRecord = "HUMAN_OBSERVATION",
        year = (paste(as.double(curr_Year)-6,",",curr_Year)),
        return = "meta"
      )$count
      year_from <- as.double(curr_Year)-6
      
      if(Delphinidae_count >= occ_Limit){
        Delphinidae_count <- occ_search(
          taxonKey = Delphinidae$key,
          hasCoordinate = TRUE,
          basisOfRecord = "HUMAN_OBSERVATION",
          year = (paste(as.double(curr_Year)-5,",",curr_Year)),
          return = "meta"
        )$count
        year_from <- as.double(curr_Year)-5
        
        if(Delphinidae_count >= occ_Limit){
          Delphinidae_count <- occ_search(
            taxonKey = Delphinidae$key,
            hasCoordinate = TRUE,
            basisOfRecord = "HUMAN_OBSERVATION",
            year = (paste(as.double(curr_Year)-4,",",curr_Year)),
            return = "meta"
          )$count
          year_from <- as.double(curr_Year)-4
          
          if(Delphinidae_count >= occ_Limit){
            Delphinidae_count <- occ_search(
              taxonKey = Delphinidae$key,
              hasCoordinate = TRUE,
              basisOfRecord = "HUMAN_OBSERVATION",
              year = (paste(as.double(curr_Year)-4,",",curr_Year)),
              limit = occ_Limit,
              return = "meta"
            )$count
            year_from <- as.double(curr_Year)-4
          }
        }
      }
    }
  }
}

#Uses previous data and makes a data frame, also sets a limit to observations
Delphinidae_Data <- occ_search(
  taxonKey = Delphinidae$key,
  basisOfRecord = "HUMAN_OBSERVATION",
  hasCoordinate = TRUE,
  year = (paste(as.double(year_from),",",curr_Year)),
  limit = Delphinidae_count,
  return = 'data'
)