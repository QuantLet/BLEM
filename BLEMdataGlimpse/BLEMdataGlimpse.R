

## Save data glimpse of energy smart meter recordings
## Author: Michael Kostmann


# Load packages
packages = c("data.table",
             "lubridate",
             "tidyverse",
             "tibbletime")
invisible(lapply(packages, library, character.only = TRUE))

# Function for easy string pasting
"%&%" = function(x, y) {paste(x, y, sep = "")}


# Specify dataset to load: select consumer or prosumer
dataset_id    = "consumer-00000056"
#dataset_id    = "producer-00000089"

# Load raw data from csv-file
raw_data      = fread(input     = dataset_id%&%".csv",
                      header    = T,
                      sep       = ',',
                      integer64 = "numeric")

raw_data$time = as_datetime(raw_data$time/1000, tz = "CET")

# Keep only timestamp, energy, and energyOut
data = raw_data %>%
    select(time,
           energy,
           energyOut) %>%
    as_tbl_time(index = time)

# Save glimpse as csv-file: Specify time interval
from = "2017-09-20 12:18:00"
to   = "2017-09-20 12:33:00"

data %>%
    filter_time(from ~ to) %>%
    write.csv("output/"%&%dataset_id%&%"_glimpse.csv")


## end of file##
