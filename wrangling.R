# Practice wrangling data

# Load packages and setup -------------------------------------------------
library(tidyverse)
library(zentracloud)

setZentracloudOptions(
  token = Sys.getenv("ZENTRACLOUD_TOKEN"),
  domain = "default"
)


# Download data -----------------------------------------------------------

# start with just a single device ID and a single day

# This device has all 3 types of soil sensors
readings <- getReadings(
  device_sn = "z6-19484",
  start_time = "2023-10-11 12:00:00",
  end_time = "2023-10-12 12:00:00"
)

# Combine data from similar sensors ---------------------------------------

# all the T12 and T21 sensor ports are soil at different locations and depths

#get just the elements that start with "T12" or "T21"
soil_list <- readings[str_detect(names(readings), "^T12|^T21")]

#combine all ports into one data frame
soil_raw <- list_rbind(soil_list, names_to = "sensor_port")

#wrangle and clean
soil_df <- soil_raw |> 
  separate_wider_delim(sensor_port, "_", names = c("sensor", "port")) |> 
  mutate(
    # remove "port" prefix because it's unecessary
    port = str_remove(port, "port"),
    # remove timezone piece of datetime and convert to datetime data type
    datetime = str_remove(datetime, "-07:00$") |> ymd_hms(tz = "America/Phoenix")
  ) |> 
  #now we no longer need timestamp and tz_offset--all info is in datetime
  select(-timestamp_utc, -tz_offset)

# example plots

ggplot(soil_df, aes(x = datetime, y = soil_temperature.value, color = port)) +
  geom_line()

ggplot(soil_df, aes(x = datetime, y = matric_potential.value, color = port)) +
  geom_line() #would need to figure out how to drop unused ports from plot


# Atmospheric data --------------------------------------------------------

atm_list <- readings[str_detect(names(readings), "^ATM")] 

atm_raw <- atm_list |> list_rbind(names_to = "sensor_port")
atm_df <- 
  atm_raw |> 
  #same as above
  separate_wider_delim(sensor_port, "_", names = c("sensor", "port")) |> 
  mutate(
    port = str_remove(port, "port"),
    datetime = str_remove(datetime, "-07:00$") |> ymd_hms(tz = "America/Phoenix")
  ) |> 
  select(-timestamp_utc, -tz_offset)

# example plot

ggplot(atm_df, aes(x = datetime, y = atmospheric_pressure.value)) +
  geom_line()  


# Apply this to multiple sensors ------------------------------------------

## Can you pass multiple sensor IDs to the download function?
# readings <- getReadings(
#   device_sn = c("z6-19484", "z6-20761"),
#   start_time = "2023-10-11 12:00:00",
#   end_time = "2023-10-12 12:00:00"
# )

## Nope! that doesn't work.

# To download data from all the sensors into a list of lists, we could use `map()`

devices <- c("z6-19484", "z6-20761", "z6-20764", "z6-20762", "z6-20763")

readings_all <- 
  # provide an "anonymous function" to map() to iterate over `devices`
  map(devices, \(x) {
    getReadings(
      device_sn = x,
      start_time = "2023-10-11 12:00:00",
      end_time = "2023-10-12 12:00:00"
    )
  })

## readings_all is now a list of lists
# str(readings_all)

# sets names of list elements
names(readings_all) <- devices

# if we want to combine atmospheric and soil sensors, it's quite easy, I think

# collapse list of lists to list of data frames
all_df <- 
  readings_all |> 
  map(\(x) list_rbind(x, names_to = "sensor_port")) |> 
  #collapse list of data frames to a single data frame
  list_rbind(names_to = "device_sn") |> 
  #same wrangling as above
  separate_wider_delim(sensor_port, "_", names = c("sensor", "port")) |> 
  mutate(
    port = str_remove(port, "port"),
    datetime = str_remove(datetime, "-07:00$") |> ymd_hms(tz = "America/Phoenix")
  ) |> 
  select(-timestamp_utc, -tz_offset)

head(all_df)

# if we want to split out the atmospheric sensors, it will be more involved.  Will need to think about data size and how much we'll really save by keeping them separate.