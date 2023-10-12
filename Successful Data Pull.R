
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


# benchmarking ------------------------------------------------------------


library(tictoc)
# 2 minutes of data
zentracloud::clearCache(file_age = 0L)
tic()
readings <- getReadings(
  device_sn = "z6-20762",
  start_time = "2023-06-01 12:00:00",
  end_time = "2023-06-01 12:02:00",
  force_api = TRUE,
  ignore_cache = TRUE
)
toc()
# 66 seconds

# 2 hours of data
tic()
readings <- getReadings(
  device_sn = "z6-20762",
  start_time = "2023-06-01 12:00:00",
  end_time = "2023-06-01 14:00:00",
  force_api = TRUE,
  ignore_cache = TRUE
)
toc()
#64 seconds

# 1 day of data
tic()
readings <- getReadings(
  device_sn = "z6-20762",
  start_time = "2023-06-01 12:00:00",
  end_time = "2023-06-02 12:00:00",
  force_api = TRUE,
  ignore_cache = TRUE
)
toc()
#64 seconds

# 3 days of data
tic()
readings <- getReadings(
  device_sn = "z6-20762",
  start_time = "2023-06-01 12:00:00",
  end_time = "2023-06-04 12:00:00",
  force_api = TRUE,
  ignore_cache = TRUE
)
toc()
#63 seconds

# 1 week of data
tic()
readings <- getReadings(
  device_sn = "z6-20762",
  start_time = "2023-06-01 12:00:00",
  end_time = "2023-06-08 12:00:00",
  force_api = TRUE,
  ignore_cache = TRUE
)
toc()
#111.556 seconds

