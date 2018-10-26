[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **BLEMpredictNaive** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml


Name of Quantlet: BLEMpredictNaive

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Generates energy consumption and production forecasts with persistence model (naive predictor) for 99 consumer and 12 prosumer datasets and calculates various error measures against true consumption values in specified testing period.

Keywords: household energy prediction, energy consumption, enerygproduction, naive predictor, persistence model, benchmark model, error measures, model performance, MAE, MAPE, MASE, RMSE, NRMSE

Author: Michael Kostmann

See also:
- BLEMdataGlimpse
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

Input: 100 consumer and prosumer datasets containing energy readings for one year (2017) in 3-minute intervals (csv-files)

Output:
- predictions of energy consumption/production in 15-minute intervals (csv-files)
- error measures calculated on testing data (Rdata-files)
```

### R Code
```r



## Make naive predictions with benchmark model, and calculate error measures
## for consumer datasets
## Author: Michael Kostmann


# Clear global environment
rm(list=ls())

# Source user-defined functions
functions = c("FUN_getData.R",
              "FUN_getTargets.R",
              "FUN_calcErrorMeasure.R")
invisible(lapply(functions, source))

# Set path of directory containing datasets
path      = "../data/consumer/"

# Set index to number between 1 and 100 to select individual dataset
# If all consumer datasets should be used, set index to -26
files     = list.files(path, pattern = "*.csv")[-26]


# Generate vector of column names
col_ids   = paste0("c", substring(files, 15, 17), "_cons")

# Load data
input     = getData(path   = path,
                    data   = "all",
                    return = "consumption")

# Initialize progress bar
pb = txtProgressBar(min = 0, max = length(files), style = 3)

# Loop over all data sets specified in files
for(i in (1:length(files))){
    
    # Get naive prediction (benchmark model)
    temp = input %>%
        filter_time("2017-10-01 00:03:00" ~ "2018-01-01") %>%
        mutate(time_aggr = collapse_index(index      = time,
                                          period     = "15 minutely",
                                          side       = "end",
                                          start_date =
                                              as_datetime(min(time),
                                                          tz = "CET"))) %>%
        group_by(time_aggr) %>%
        summarise(prediction = sum(!!sym(col_ids[i]))) %>%
        pull(prediction)
    
    # Correct last aggregation value
    temp[(length(temp)-1)] = temp[(length(temp)-1)] + temp[length(temp)]
    temp                   = temp[-length(temp)]
    
    # Shift by one period
    naive_predictions = c(NA, temp[-length(temp)])
    
    # Get true values
    targets = getTargets(path   = path,
                         id     = substring(files[i], 1, 17),
                         return = "consumption",
                         min    = "2017-10-01 00:03",
                         max    = "2018-01-01 00:00")
    
    # Write error measures of naive prediction into list
    if(!exists("error_measures")) {error_measures = list()}
    error_measures[[col_ids[i]]] =
        calcErrorMeasure(predictions = naive_predictions[-1],
                         targets     = targets[-1],
                         return      = "all")
    
    # Save predictions to dataframe
    if(!exists("naive_all_predictions")) {
        naive_all_predictions = matrix(NA,
                                       nrow = length(naive_predictions),
                                       ncol = length(files))
    }
    naive_all_predictions[, i] = naive_predictions
    
    # Progress
    setTxtProgressBar(pb, i)
}

# Save error measures
save(error_measures, file = "output/consumer/naive_error_measures.RData")

# Save predictions for all datasets to csv-file
write.csv(naive_all_predictions, "output/consumer/naive_predictions.csv")




###############################################################################




## Make naive predictions with benchmark model, and calculate error measures
## for prosumer datasets


# Clear global environment except for functions
rm(list = setdiff(ls(), lsf.str()))

# Set path to directory containing datasets
path      = "../data/prosumer/"

# Set index to number between 1 and 100 to select individual dataset
files     = list.files(path,
                       pattern = "*.csv")[c(19, 24, 26, 30, 31, 72,
                                            75, 83, 84, 85, 86, 89)]

# Generate vector of column names
col_ids   = paste0("p", substring(files, 15, 17), "_prod")

# Load data
input     = getData(path   = path,
                    data   = "all",
                    return = "production")[c( 1, 20, 25, 27, 31, 32, 73,
                                              76, 84, 85, 86, 87, 90)]

# Initialize progress bar
pb = txtProgressBar(min = 0, max = length(files), style = 3)

# Loop over all data sets specified in files
for(i in (1:length(files))){
    
    # Get naive prediction (benchmark model)
    temp = input %>%
        filter_time("2017-10-01 00:03:00" ~ "2018-01-01") %>%
        mutate(time_aggr = collapse_index(index      = time,
                                          period     = "15 minutely",
                                          side       = "end",
                                          start_date =
                                              as_datetime(min(time),
                                                          tz = "CET"))) %>%
        group_by(time_aggr) %>%
        summarise(prediction = sum(!!sym(col_ids[i]))) %>%
        pull(prediction)
    
    # Correct last aggregation value
    temp[(length(temp)-1)] = temp[(length(temp)-1)] + temp[length(temp)]
    temp                   = temp[-length(temp)]
    
    # Shift by one period
    naive_predictions = c(NA, temp[-length(temp)])
    
    # Get true values
    targets = getTargets(path   = path,
                         id     = substring(files[i], 1, 17),
                         return = "production",
                         min    = "2017-10-01 00:03",
                         max    = "2018-01-01 00:00")
    
    # Write error measures of naive prediction into list
    if(!exists("error_measures")) {error_measures = list()}
    error_measures[[col_ids[i]]] =
        calcErrorMeasure(predictions = naive_predictions[-1],
                         targets     = targets[-1],
                         return      = "all")
    
    # Save predictions to dataframe
    if(!exists("naive_all_predictions")) {
        naive_all_predictions = matrix(NA,
                                       nrow = length(naive_predictions),
                                       ncol = length(files))
    }
    naive_all_predictions[, i] = naive_predictions
    
    # Progress
    setTxtProgressBar(pb, i)
}

# Save error measures
save(error_measures, file = "output/prosumer/naive_error_measures.RData")

# Save predictions for all datasets to csv-file
write.csv(naive_all_predictions, "output/prosumer/naive_predictions.csv")


## end of file ##

```

automatically created on 2018-10-26