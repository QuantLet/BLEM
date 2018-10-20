

## Function: loadErrorMeasures


## Args:     path    - path of the directory that contains .RData-file
##                     of saved error measures to load
##           return  - character vector of which error measures from
##                     loaded list to return:
##                     "MAE", MAPE", "MASE", "MSE", "RMSE", "NRMSE"
##           remove  - which consumer/producer datasets' error measures
##                     to remove, provided as index.
##                     
##                                            
##       
## Returns:  measures - large list of all error measures specified in "return"
##                      for all three prediction models for all datasets not
##                      specified in "remove"



loadErrorMeasures = function(path, return, remove = NULL) {
    
    # Function for easy string pasting
    "%&%" = function(x, y) {paste(x, y, sep = "")}
    
    # Load packages
    library("purrr")
    
    # Initiate list
    measures = list()
    
    # Load naive-predicted consumption values and error measures
    load(path%&%"naive_error_measures.RData")
    if(!is.null(remove)) {
        del = names(error_measures)[remove]
        error_measures = error_measures[!names(error_measures) %in% del]
    }
    measures$naive_all = error_measures
    rm(error_measures)
    
    # Extract individual error measures for naive prediction
    for(i in return){
        measures[["naive_"%&%i]] = map_dbl(measures$naive_all, i)
    }
    
    # Load LASSO-predicted consumption values and error measures
    load(path%&%"/LASSO_error_measures.RData")
    if(!is.null(remove)) {
        del = names(error_measures)[remove]
        error_measures = error_measures[!names(error_measures) %in% del]
    }
    measures$LASSO_all = error_measures
    rm(error_measures)
    
    # Extract individual error measures for LASSO prediction
    for(i in return){
        measures[["LASSO_"%&%i]] = map_dbl(measures$LASSO_all, i)
    }
    
    # Load LSTM-predicted consumption values and error measures
    load(path%&%"LSTM_error_measures.RData")
    if(!is.null(remove)) {
        del = names(error_measures)[remove]
        error_measures = error_measures[!names(error_measures) %in% del]
    }
    measures$LSTM_all = error_measures
    rm(error_measures)

    # Extract individual error measures for LSTM prediction
    for(i in return){
        measures[["LSTM_"%&%i]] = map_dbl(measures$LSTM_all, i)
    }
    
    return(measures)
    
}
