

## Make naive predictions with benchmark model, and calculate error measures
## Consumer datasets

# Clear global environment
rm(list=ls())

# Source user-defined functions
functions <- c("FUN_getData.R", "FUN_getTargets.R", "FUN_calcErrorMeasure.R")
invisible(lapply(functions, source))

# Set path of directory containing datasets
path <- "data/consumer/"

# Set index to number between 1 and 100 to select individual dataset
# If all consumer datasets should be used, set index to -26
files <- list.files(path, pattern = "*.csv")[-26]


# Generate vector of column names
col_ids <- paste0("c", substring(files, 15, 17), "_cons")

# Load data
input <- getData(path   = path,
                 data   = "all",
                 return = "consumption")

# Initialize progress bar
pb <- txtProgressBar(min = 0, max = length(files), style = 3)

for(i in (1:length(files))){
    
    # Get naive prediction (benchmark model)
    temp <- input %>%
        filter_time("2017-10-01 00:03:00" ~ "2018-01-01") %>%
        mutate(time_aggr = collapse_index(index = time,
                                          period = "15 minutely",
                                          side = "end",
                                          start_date =
                                              as_datetime(min(time),
                                                          tz = "CET"))) %>%
        group_by(time_aggr) %>%
        summarise(prediction = sum(!!sym(col_ids[i]))) %>%
        pull(prediction)
    
    temp[(length(temp)-1)] <- temp[(length(temp)-1)] + temp[length(temp)]
    temp <- temp[-length(temp)]
    
    naive_predictions <- c(NA, temp[-length(temp)])
    
    # Get true values
    targets <- getTargets(path,
                          substring(files[i], 1, 17),
                          return = "consumption",
                          min = "2017-10-01 00:03",
                          max = "2018-01-01 00:00")
    
    # Write error measures of naive prediction into list
    if(!exists("error_measures")) {error_measures <- list()}
    error_measures[[col_ids[i]]] <- calcErrorMeasure(naive_predictions[-1],
                                             targets[-1],
                                             return = "all")
    
    # Save predictions to dataframe
    if(!exists("naive_all_predictions")) {
        naive_all_predictions <- matrix(NA,
                                        nrow = length(naive_predictions),
                                        ncol = length(files))
    }
    
    naive_all_predictions[, i] <- naive_predictions
    
    # Progress
    setTxtProgressBar(pb, i)
}

# Extract individual error measures
measures <- c("MAE", "MAPE", "MASE", "MSE", "RMSE", "NRMSE")

for(i in measures){
    assign(i, map_dbl(error_measures, i))
    print(i)
    print(summary(get(i)))
}

# Save error measures
save(error_measures, file = "output/consumer/naive_error_measures.RData")

# Save predictions for all datasets to csv-file
write.csv(naive_all_predictions, "output/consumer/naive_predictions.csv")


## end of file ##
