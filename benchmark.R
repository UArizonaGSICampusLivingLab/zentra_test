# benchmarking ------------------------------------------------------------
# Why does downloading data take so long?  Issue opened here: https://gitlab.com/meter-group-inc/pubpackages/zentracloud/-/issues/39

# install.packages('zentracloud', repos = c('https://cct-datascience.r-universe.dev', 'https://cloud.r-project.org'))
library(zentracloud)
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
