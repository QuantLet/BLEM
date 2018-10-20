

## Calculate means  and medians of error measures and save as csv-file
## Author: Michael Kostmann


# Load packages
# packages  = c("cowplot")#, "IDPmisc")
# invisible(lapply(packages, library, character.only = TRUE))

# Load user-defined functions
functions = c("FUN_loadErrorMeasures.R")
invisible(lapply(functions, source))

# Function for easy string pasting
"%&%"     = function(x, y) {paste(x, y, sep = "")}


# Define vector with names of error measures
measures        = c("MAE", "MAPE", "MASE", "MSE", "RMSE", "NRMSE")
measures_median = c("MAE", "MdAPE", "MASE", "MSE", "RMSE", "NRMdSE")


### Mean of error measures


## CONSUMER ##


# Define vector of datasets to exclude from error analysis
remove   = c(13, 21, 34, 45, 52, 56, 66, 75, 77, 79, 81)

# Load error measures
error_measures_c        = loadErrorMeasures("predictions/consumer/",
                                            return = measures,
                                            remove = remove)

error_measures_c_median = loadErrorMeasures("predictions/consumer_median/",
                                            return = measures_median,
                                            remove = remove)

# Generate dataframe for table
avg_errM_c_mean = data.frame(
    
    "Model"  = c("LSTM",
                 "LASSO",
                 "Benchmark",
                 "Improvement LSTM (in %)",
                 "Improvement LASSO (in %)"),
    
    
    "MAE"    = c(mean(error_measures_c[["LSTM_MAE"]]),
                 
                 mean(error_measures_c[["LASSO_MAE"]]),
                 
                 mean(error_measures_c[["naive_MAE"]]),
                 
                 100*(mean(error_measures_c[["naive_MAE"]]) -
                          mean(error_measures_c[["LSTM_MAE"]])) /
                     mean(error_measures_c[["naive_MAE"]]),
                 
                 100*(mean(error_measures_c[["naive_MAE"]]) -
                          mean(error_measures_c[["LASSO_MAE"]])) /
                     mean(error_measures_c[["naive_MAE"]])),
    
    
    "RMSE"   = c(mean(error_measures_c[["LSTM_RMSE"]]),
                 
                 mean(error_measures_c[["LASSO_RMSE"]]),
                 
                 mean(error_measures_c[["naive_RMSE"]]),
                 
                 100*(mean(error_measures_c[["naive_RMSE"]]) -
                          mean(error_measures_c[["LSTM_RMSE"]])) /
                     mean(error_measures_c[["naive_RMSE"]]),
                 
                 100*(mean(error_measures_c[["naive_RMSE"]]) -
                          mean(error_measures_c[["LASSO_RMSE"]])) /
                     mean(error_measures_c[["naive_RMSE"]])),
    
    
    "MAPE"   = c(mean(error_measures_c[["LSTM_MAPE"]]),
                 
                 mean(error_measures_c[["LASSO_MAPE"]]),
                 
                 mean(error_measures_c[["naive_MAPE"]]),
                 
                 100*(mean(error_measures_c[["naive_MAPE"]]) -
                          mean(error_measures_c[["LSTM_MAPE"]])) /
                     mean(error_measures_c[["naive_MAPE"]]),
                 
                 100*(mean(error_measures_c[["naive_MAPE"]]) -
                          mean(error_measures_c[["LASSO_MAPE"]])) /
                     mean(error_measures_c[["naive_MAPE"]])),
    
    
    # "MdAPE"  = c(mean(error_measures_c_median[["LSTM_MdAPE"]]),
    # 
    #              mean(error_measures_c_median[["LASSO_MdAPE"]]),
    # 
    #              mean(error_measures_c_median[["naive_MdAPE"]]),
    # 
    #              100*(mean(error_measures_c_median[["naive_MdAPE"]]) -
    #                       mean(error_measures_c_median[["LSTM_MdAPE"]])) /
    #                  mean(error_measures_c_median[["naive_MdAPE"]]),
    # 
    #              100*(mean(error_measures_c_median[["naive_MdAPE"]]) -
    #                       mean(error_measures_c_median[["LASSO_MdAPE"]])) /
    #                  mean(error_measures_c_median[["naive_MdAPE"]])),
    
    
    "NRMSE"  = c(mean(error_measures_c[["LSTM_NRMSE"]]),
                 
                 mean(error_measures_c[["LASSO_NRMSE"]]),
                 
                 mean(error_measures_c[["naive_NRMSE"]]),
                 
                 100*(mean(error_measures_c[["naive_NRMSE"]]) -
                          mean(error_measures_c[["LSTM_NRMSE"]])) /
                     mean(error_measures_c[["naive_NRMSE"]]),
                 
                 100*(mean(error_measures_c[["naive_NRMSE"]]) -
                          mean(error_measures_c[["LASSO_NRMSE"]])) /
                     mean(error_measures_c[["naive_NRMSE"]])),
    
    
    # "NRMdSE" = c(mean(error_measures_c_median[["LSTM_NRMdSE"]]),
    # 
    #              mean(error_measures_c_median[["LASSO_NRMdSE"]]),
    # 
    #              mean(error_measures_c_median[["naive_NRMdSE"]]),
    # 
    #              100*(mean(error_measures_c_median[["naive_NRMdSE"]]) -
    #                       mean(error_measures_c_median[["LSTM_NRMdSE"]])) /
    #                  mean(error_measures_c_median[["naive_NRMdSE"]]),
    # 
    #              100*(mean(error_measures_c_median[["naive_NRMdSE"]]) -
    #                       mean(error_measures_c_median[["LASSO_NRMdSE"]])) /
    #                  mean(error_measures_c_median[["naive_NRMdSE"]])),
    
    
    "MASE"   = c(mean(error_measures_c[["LSTM_MASE"]]),
                 
                 mean(error_measures_c[["LASSO_MASE"]]),
                 
                 mean(error_measures_c[["naive_MASE"]]),
                 
                 100*(mean(error_measures_c[["naive_MASE"]]) -
                          mean(error_measures_c[["LSTM_MASE"]])) /
                     mean(error_measures_c[["naive_MASE"]]),
                 
                 100*(mean(error_measures_c[["naive_MASE"]]) -
                          mean(error_measures_c[["LASSO_MASE"]])) /
                     mean(error_measures_c[["naive_MASE"]]))
)

# Save to file  
write.csv(avg_errM_c_mean, file = "tables/avg_errorMeasures_c.csv")
# write.csv(avg_errM_c_mean, file = "tables/avg_errorMeasures_c_median.csv")


### PROSUMER ###


# Load error measures
error_measures_p = loadErrorMeasures("predictions/prosumer/",
                                      return = measures,
                                      remove = NULL)

# Generate dataframe for table
avg_errM_p_mean = data.frame(
    
    "Model" = c("LSTM",
                "LASSO",
                "Benchmark",
                "Improvement LSTM (in %)",
                "Improvement LASSO (in %)"),
    
    
    "MAE"   = c(mean(error_measures_p[["LSTM_MAE"]]),
                
                mean(error_measures_p[["LASSO_MAE"]]),
                
                mean(error_measures_p[["naive_MAE"]]),
                
                100*(mean(error_measures_p[["naive_MAE"]]) -
                         mean(error_measures_p[["LSTM_MAE"]])) /
                    mean(error_measures_p[["naive_MAE"]]),
                
                100*(mean(error_measures_p[["naive_MAE"]]) -
                         mean(error_measures_p[["LASSO_MAE"]])) /
                    mean(error_measures_p[["naive_MAE"]])),
    
    
    "RMSE"  = c(mean(error_measures_p[["LSTM_RMSE"]]),
                
                mean(error_measures_p[["LASSO_RMSE"]]),
                
                mean(error_measures_p[["naive_RMSE"]]),
                
                100*(mean(error_measures_p[["naive_RMSE"]]) -
                         mean(error_measures_p[["LSTM_RMSE"]])) /
                    mean(error_measures_p[["naive_RMSE"]]),
                
                100*(mean(error_measures_p[["naive_RMSE"]]) -
                         mean(error_measures_p[["LASSO_RMSE"]])) /
                    mean(error_measures_p[["naive_RMSE"]])),
    
    
    "MASE"  = c(mean(error_measures_p[["LSTM_MASE"]]),
                
                mean(error_measures_p[["LASSO_MASE"]]),
                
                mean(error_measures_p[["naive_MASE"]]),
                
                100*(mean(error_measures_p[["naive_MASE"]]) -
                         mean(error_measures_p[["LSTM_MASE"]])) /
                    mean(error_measures_p[["naive_MASE"]]),
                
                100*(mean(error_measures_p[["naive_MASE"]]) -
                         mean(error_measures_p[["LASSO_MASE"]])) /
                    mean(error_measures_p[["naive_MASE"]]))
)

# Save to file
write.csv(avg_errM_p_mean, file = "tables/avg_errorMeasures_p.csv")


### Median of error measures


###  CONSUMER  ###


# Generate dataframe for table
avg_errM_c_median = data.frame(
    
    "Model"  = c("LSTM",
                 "LASSO",
                 "Benchmark",
                 "Improvement LSTM (in %)",
                 "Improvement LASSO (in %)"),
    
    
    "MAE"    = c(median(error_measures_c[["LSTM_MAE"]]),
                 
                 median(error_measures_c[["LASSO_MAE"]]),
                 
                 median(error_measures_c[["naive_MAE"]]),
                 
                 100*(median(error_measures_c[["naive_MAE"]]) -
                          median(error_measures_c[["LSTM_MAE"]])) /
                     median(error_measures_c[["naive_MAE"]]),
                 
                 100*(median(error_measures_c[["naive_MAE"]]) -
                          median(error_measures_c[["LASSO_MAE"]])) /
                     median(error_measures_c[["naive_MAE"]])),
    
    
    "RMSE"   = c(median(error_measures_c[["LSTM_RMSE"]]),
                 
                 median(error_measures_c[["LASSO_RMSE"]]),
                 
                 median(error_measures_c[["naive_RMSE"]]),
                 
                 100*(median(error_measures_c[["naive_RMSE"]]) -
                          median(error_measures_c[["LSTM_RMSE"]])) /
                     median(error_measures_c[["naive_RMSE"]]),
                 
                 100*(median(error_measures_c[["naive_RMSE"]]) -
                          median(error_measures_c[["LASSO_RMSE"]])) /
                     median(error_measures_c[["naive_RMSE"]])),
    
    
    "MAPE"   = c(median(error_measures_c[["LSTM_MAPE"]]),
                 
                 median(error_measures_c[["LASSO_MAPE"]]),
                 
                 median(error_measures_c[["naive_MAPE"]]),
                 
                 100*(median(error_measures_c[["naive_MAPE"]]) -
                          median(error_measures_c[["LSTM_MAPE"]])) /
                     median(error_measures_c[["naive_MAPE"]]),
                 
                 100*(median(error_measures_c[["naive_MAPE"]]) -
                          median(error_measures_c[["LASSO_MAPE"]])) /
                     median(error_measures_c[["naive_MAPE"]])),
    
    
    "NRMSE"  = c(median(error_measures_c[["LSTM_NRMSE"]]),
                 
                 median(error_measures_c[["LASSO_NRMSE"]]),
                 
                 median(error_measures_c[["naive_NRMSE"]]),
                 
                 100*(median(error_measures_c[["naive_NRMSE"]]) -
                          median(error_measures_c[["LSTM_NRMSE"]])) /
                     median(error_measures_c[["naive_NRMSE"]]),
                 
                 100*(median(error_measures_c[["naive_NRMSE"]]) -
                          median(error_measures_c[["LASSO_NRMSE"]])) /
                     median(error_measures_c[["naive_NRMSE"]])),

    
    "MASE"   = c(median(error_measures_c[["LSTM_MASE"]]),
                 
                 median(error_measures_c[["LASSO_MASE"]]),
                 
                 median(error_measures_c[["naive_MASE"]]),
                 
                 100*(median(error_measures_c[["naive_MASE"]]) -
                          median(error_measures_c[["LSTM_MASE"]])) /
                     median(error_measures_c[["naive_MASE"]]),
                 
                 100*(median(error_measures_c[["naive_MASE"]]) -
                          median(error_measures_c[["LASSO_MASE"]])) /
                     median(error_measures_c[["naive_MASE"]]))
)

# Save to file  
write.csv(avg_errM_c_median, file = "tables/median_errorMeasures_c.csv")


### PROSUMER ###


# Generate dataframe for table
avg_errM_p_median = data.frame(
    
    "Model" = c("LSTM",
                "LASSO",
                "Benchmark",
                "Improvement LSTM (in %)",
                "Improvement LASSO (in %)"),
    
    
    "MAE"   = c(median(error_measures_p[["LSTM_MAE"]]),
                
                median(error_measures_p[["LASSO_MAE"]]),
                
                median(error_measures_p[["naive_MAE"]]),
                
                100*(median(error_measures_p[["naive_MAE"]]) -
                         median(error_measures_p[["LSTM_MAE"]])) /
                    median(error_measures_p[["naive_MAE"]]),
                
                100*(median(error_measures_p[["naive_MAE"]]) -
                         median(error_measures_p[["LASSO_MAE"]])) /
                    median(error_measures_p[["naive_MAE"]])),
    
    
    "RMSE"  = c(median(error_measures_p[["LSTM_RMSE"]]),
                
                median(error_measures_p[["LASSO_RMSE"]]),
                
                median(error_measures_p[["naive_RMSE"]]),
                
                100*(median(error_measures_p[["naive_RMSE"]]) -
                         median(error_measures_p[["LSTM_RMSE"]])) /
                    median(error_measures_p[["naive_RMSE"]]),
                
                100*(median(error_measures_p[["naive_RMSE"]]) -
                         median(error_measures_p[["LASSO_RMSE"]])) /
                    median(error_measures_p[["naive_RMSE"]])),
    
    
    "MASE"  = c(median(error_measures_p[["LSTM_MASE"]]),
                
                median(error_measures_p[["LASSO_MASE"]]),
                
                median(error_measures_p[["naive_MASE"]]),
                
                100*(median(error_measures_p[["naive_MASE"]]) -
                         median(error_measures_p[["LSTM_MASE"]])) /
                    median(error_measures_p[["naive_MASE"]]),
                
                100*(median(error_measures_p[["naive_MASE"]]) -
                         median(error_measures_p[["LASSO_MASE"]])) /
                    median(error_measures_p[["naive_MASE"]]))
)

# Save to file
write.csv(avg_errM_p_median, file = "tables/median_errorMeasures_p.csv")


## end of file ##
