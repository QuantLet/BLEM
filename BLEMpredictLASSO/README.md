[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **BLEMpredictLASSO** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml


Name of Quantlet: BLEMpredictLASSO

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Fits LASSO regression models for 99 consumer and 12 prosumer data sets with k-fold cross-validation, uses fitted models to make predictions in testing period and calculates various error measures for model performance.

Keywords: household energy prediction, energy consumption, energy production, LASSO, machine learning, cross-validation, regression model, error measures, model performance, MAE, MAPE, MASE, RMSE, NRMSE

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



## Make predictions with LASSO model, and calculate error measures
## for consumer datasets
## Author: Michael Kostmann


# Clear global environment
rm(list=ls())

# Load packages
packages  = c("glmnet",
              "doParallel")
invisible(lapply(packages, library, character.only = TRUE))

# Source user-defined functions
functions = c("FUN_getData.R",
              "FUN_getTargets.R",
              "FUN_slidingLASSOWindows.R", 
              "FUN_calcErrorMeasure.R")
invisible(lapply(functions, source))

# Specify path to directory with consumer datasets
path      = "../data/consumer"  #use this path if using windows
#path      = "../data/consumer/"  #use this path if using mac

# Set index to number between 1 and 100 to select individual dataset;
# if all consumer datasets should be used, set index to -26

#use this path if using windows
files = paste0("/", substring(list.files(path, pattern = "*.csv"), 1, 17))[-26]

#use this path if using mac
#files = substring(list.files(path, pattern = "*.csv"), 1, 17)[-26]

# Initialize progress bar, set seed, register cores
pb = txtProgressBar(min = 0, max = length(files), style = 3)
set.seed(20180925)
registerDoParallel(cores = detectCores()-1)

# Loop over data sets specified in files
for(id in files) {
    
    # Get data
    data = getData(path   = path,
                   data   = "single",
                   id     = id,
                   return = "consumption")
    
    # Transform dataset to get training set
    pred_matrix_train = slidingLASSOWindows(data,
                                            start.train = "2017-01-01 00:00",
                                            end.train   = "2017-09-30 23:57",
                                            window.size = 3360,
                                            aggr        = 5)
    
    # Get targets
    y = getTargets(path   = path,
                   id     = id,
                   return = "consumption",
                   min    = "2017-01-08 00:00",
                   max    = "2017-10-01 00:00")
    
    # Estimate coefficients with cross-validation
    lasso = cv.glmnet(pred_matrix_train, y,
                      alpha        = 1,
                      parallel     = TRUE,
                      type.measure = "mae")
    
    # Predict on testing set
    pred_matrix_test =  slidingLASSOWindows(data,
                                            start.train = "2017-09-24 00:03",
                                            end.train   = "2018-01-01 00:00",
                                            window.size = 3360,
                                            aggr        = 5)
    
    lasso_predictions = predict(lasso,
                                newx = pred_matrix_test,
                                s    = "lambda.1se",
                                type = "link")
    
    # Get true values
    targets = getTargets(path    = path,
                         id     = id,
                         return = "consumption",
                         min    = "2017-10-01 00:00",
                         max    = "2018-01-01 00:00")
    
    # Calculate error measures
    if(!exists("error_measures")) {error_measures = list()}
    error_measures[[substring(id, 2, 27)]] =
        calcErrorMeasure(predictions = lasso_predictions,
                         targets     = targets,
                         return      = "all")
    
    # Print progress to console
    setTxtProgressBar(pb, which(id == files))
    print(Sys.time())
    
    # Save predictions to dataframe
    if(!exists("lasso_all_predictions")) {
        lasso_all_predictions = matrix(NA,
                                       nrow = length(lasso_predictions),
                                       ncol = length(files))
        col = 0
    }
    
    col = col+1
    lasso_all_predictions[, col] = lasso_predictions
    
}

# Save error measures
save(error_measures, file = "output/consumer/LASSO_error_measures.RData")

# Save predictions for all datasets to csv-file
write.csv(lasso_all_predictions, "output/consumer/LASSO_predictions.csv")




###############################################################################




## Make predictions with LASSO model, and calculate error measures
## for prosumer datasets


# Clear global environment except for functions
rm(list = setdiff(ls(), lsf.str()))

# Specify path to directory with prosumer datasets
path      = "../data/prosumer"  #use this path if using windows
#path      = "../data/prosumer/"  #use this path if using mac

# Set index to number between 1 and 100 to select individual dataset;
# if all consumer datasets should be used, set index to -26

#use this path if using windows
files = paste0("/", substring(list.files(path, pattern = "*.csv"),
                              1,
                              17))[c(19, 24, 26, 30, 31, 72,
                                     75, 83, 84, 85, 86, 89)]

#use this path if using mac
#files = substring(list.files(path, pattern = "*.csv"),
#                   1,
#                   17)[c(19, 24, 26, 30, 31, 72,
#                         75, 83, 84, 85, 86, 89)]

# Initialize progress bar, set seed, register cores
pb = txtProgressBar(min = 0, max = length(files), style = 3)
set.seed(20180925)
registerDoParallel(cores = detectCores()-1)

# Loop over data sets specified in files
for(id in files) {
    
    # Get data
    data = getData(path   = path,
                   data   = "single",
                   id     = id,
                   return = "production")
    
    # Transform dataset to get training set
    pred_matrix_train = slidingLASSOWindows(data,
                                            start.train = "2017-01-01 00:00",
                                            end.train   = "2017-09-30 23:57",
                                            window.size = 3360,
                                            aggr        = 5)
    
    # Get targets
    y = getTargets(path   = path,
                   id     = id,
                   return = "production",
                   min    = "2017-01-08 00:00",
                   max    = "2017-10-01 00:00")
    
    # Estimate coefficients with cross-validation
    lasso = cv.glmnet(pred_matrix_train, y,
                      alpha        = 1,
                      parallel     = TRUE,
                      type.measure = "mae")
    
    # Predict on testing set
    pred_matrix_test =  slidingLASSOWindows(data,
                                            start.train = "2017-09-24 00:03",
                                            end.train   = "2018-01-01 00:00",
                                            window.size = 3360,
                                            aggr        = 5)
    
    lasso_predictions = predict(lasso,
                                newx = pred_matrix_test,
                                s    = "lambda.1se",
                                type = "link")
    
    # Get true values
    targets = getTargets(path   = path,
                         id     = id,
                         return = "production",
                         min    = "2017-10-01 00:00",
                         max    = "2018-01-01 00:00")
    
    # Calculate error measures
    if(!exists("error_measures")) {error_measures = list()}
    error_measures[[substring(id, 2, 27)]] =
        calcErrorMeasure(predictions = lasso_predictions,
                         targets     = targets,
                         return      = "all")
    
    # Print progress to console
    setTxtProgressBar(pb, which(id == files))
    print(Sys.time())
    
    # Save predictions to dataframe
    if(!exists("lasso_all_predictions")) {
        lasso_all_predictions = matrix(NA,
                                       nrow = length(lasso_predictions),
                                       ncol = length(files))
        col = 0
    }
    
    col = col+1
    lasso_all_predictions[, col] = lasso_predictions
    
}

# Save error measures
save(error_measures, file = "output/prosumer/LASSO_error_measures.RData")

# Save predictions for all datasets to csv-file
write.csv(lasso_all_predictions, "output/prosumer/LASSO_predictions.csv")


## end of file ##

```

automatically created on 2018-10-25