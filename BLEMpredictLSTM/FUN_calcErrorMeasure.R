

## Function: calcErrorMeasure
## Author: Michael Kostmann

## Args:     predictions    - numeric vector with predictions
##           targets        - numeric vector with true values
##           return         - what to return: "errors",
##                                            "MAE",
##                                            "MAPE",
##                                            "MASE",
##                                            "MSE",
##                                            "RMSE",
##                                            "NRMSE",
##                                            "all"
##       
## Returns:  depending on arg "return:
##                      - "error":    vector of absolute deviations (errors)
##                      - "all":      list containing error vector plus single
##                                    values for each error measure
##                      - all other:  single value (result of error measure)



calcErrorMeasure = function(predictions, targets, return = "error") {
    
    # Supress start of browser by error handler
    stop_nobrowser = function(x) {
        opt = options()
        options(error = NULL)
        on.exit(options(opt))
        stop(x, call. = FALSE)
    }
    
    # Check wether prediction vector and target vectors have same length
    if(length(predictions) != length(targets)) {
        stop_nobrowser("Predictions and targets do not have same length")
    }
    
    # Calculate absolute errors, and absolute and relative error measures
    abs_error = abs(predictions - targets)
    MAE       = mean(abs_error)
    MAPE      = mean(abs_error/targets)*100
    MSE       = mean((predictions - targets)^2)
    RMSE      = sqrt(MSE)
    NRMSE     = sqrt(mean(((predictions - targets)/targets)^2)*100)
    
    n         = length(targets)
    MASE      = MAE / (1/(n-1) * sum(abs(targets[2:n] - targets[1:(n-1)])))
    
    # Return requested values
    switch(return,
           "errors" = return(abs_error),
           "MAE"    = return(MAE),
           "MAPE"   = return(MAPE),
           "MASE"   = return(MASE),
           "MSE"    = return(MSE),
           "RMSE"   = return(RMSE),
           "NRMSE"  = return(NRMSE),
           "all"    = return(list("errors" = abs_error,
                                  "MAE"    = MAE,
                                  "MAPE"   = MAPE,
                                  "MSE"    = MSE,
                                  "RMSE"   = RMSE,
                                  "NRMSE"  = NRMSE,
                                  "MASE"   = MASE)))
}
