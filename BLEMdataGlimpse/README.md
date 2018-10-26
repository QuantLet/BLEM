[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **BLEMdataGlimpse** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml


Name of Quantlet: BLEMdataGlimpse

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Generates csv-file with extract of the input data to exemplify data structure in table format.

Keywords: table, csv-file, energy data, extract, glimpse, time series, energy production, energy consumption, data snippet

Author: Michael Kostmann

See also:
- BLEMdescStatEnergyData
- BLEMevaluateEnergyPreds
- BLEMevaluateMarketSim
- BLEMmarketSimulation
- BLEMplotEnergyData
- BLEMplotEnergyPreds
- BLEMplotPredErrors
- BLEMpredictLASSO
- BLEMpredictLSTM
- BLEMpredictNaive
- BLEMtuneLSTM
- BLEMplotScalingForLSTM

Submitted:  26.10.2018

Datafile:
- consumer-00000056.csv
- producer-00000089.csv

Input: dataset containing time series of energy consumer/prosumer's electricity readings and timestamps

Output: dataset containing extract of the input data within specified time interval
```

### R Code
```r



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


# Specify datasets to load
dataset_ids    = c("consumer/consumer-00000056",
                   "prosumer/producer-00000089")

# Loop over datasets specified in datasets_ids
for(i in dataset_ids) {
    
    # Load raw data from csv-file
    raw_data      = fread(input     = "../data/"%&%i%&%".csv",
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
        write.csv(substring(i, 10, 26)%&%"_glimpse.csv")
    
}


## end of file##

```

automatically created on 2018-10-26