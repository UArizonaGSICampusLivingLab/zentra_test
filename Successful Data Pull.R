
# install.packages('zentracloud', repos = c('https://cct-datascience.r-universe.dev', 'https://cloud.r-project.org'))

library(zentracloud)
library(skimr)
library(tidyverse)

setZentracloudOptions(
  token = Sys.getenv("ZENTRACLOUD_TOKEN"),
  domain = "default"
)

getZentracloudOptions()


readings <- getReadings(
  device_sn = "z6-20762",
  start_time = "2023-06-01 12:00:00",
  end_time = "2023-06-02 12:00:00"
)
readings
names(readings)

readings |> map(skim)

# looks like last entry is empty, so maybe we can get rid of it

readings |> chuck("_port6")


settings = queryDeviceSettings(
  device_sn = "z6-20762"
)

settings  #contains lat, lon, altitude

#' Questions:
#' - Are there other device_sn ID's we need to get data from?
#'    - 6 total device_sn
#' - What are the different ports?  Do we need all ports?  All values from all ports?
#'    - port 6 is empty and currently unused
#' - TI-12 = https://www.onsetcomp.com/products/sensors/rxw-t12-xxx? Are ports different soil depths?
#' - ATM is atmospheric, yeah?



