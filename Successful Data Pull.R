
# renv::install("gitlab::meter-group-inc/pubpackages/zentracloud")

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
  end_time = "2023-06-02 12:00:00",
  force_api = FALSE,
  ignore_cache = FALSE
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
#' - What are the different ports?  Do we need all ports?  All values from all ports?
#' - TI-12 = https://www.onsetcomp.com/products/sensors/rxw-t12-xxx? Are ports different soil depths?
#' - ATM is atmospheric, yeah?
