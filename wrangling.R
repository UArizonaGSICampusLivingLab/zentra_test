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
device <- "z6-20762"

readings <- getReadings(
  device_sn = device,
  start_time = "2023-10-11 12:00:00",
  end_time = "2023-10-12 12:00:00"
)


# Combine data from similar sensors ---------------------------------------

# all the T12 sensor ports are soil probes at different locations and depths

#get just the elements that start with "T12"
T12 <- readings[str_detect(names(readings), "T12")]

#combine all ports into one data frame
T12_df_raw <- list_rbind(T12, names_to = "sensor_port")

#wrangle and clean
T12_df <- T12_df_raw |> 
  separate_wider_delim(sensor_port, "_", names = c("sensor", "port")) |> 
  mutate(
    # remove "port" prefix because it's unecessary
    port = str_remove(port, "port"),
    # remove timezone piece of datetime and convert to datetime data type
    datetime = str_remove(datetime, "-07:00$") |> ymd_hms(tz = "America/Phoenix")
  ) |> 
  #now we no longer need timestamp and tz_offset--all info is in datetime
  select(-timestamp_utc, -tz_offset)

# example plot

ggplot(T12_df, aes(x = datetime, y = soil_temperature.value, color = port)) +
  geom_line()


# Atmospheric data --------------------------------------------------------

ATM_df <- readings$`ATM-410007711_port1` |> 
  mutate(
    sensor = "ATM-41000771",
    port = 1,
    datetime = str_remove(datetime, "-07:00$") |> ymd_hms(tz = "America/Phoenix")
  ) |> 
  select(-timestamp_utc, -tz_offset)

# example plot

ggplot(ATM_df, aes(x = datetime, y = atmospheric_pressure.value)) +
  geom_line()  
