

## Function: slidingLASSOWindows
## Author: Michael Kostmann

## Args:     data        - tibble time data frame of one consumer/prosumer
##                         dataset
##           start.train - start date and time of training data
##           end.train   - end date and time of training data
##           window.size - number of data points that should be included as
##                         predictors (3360 equals 3360 data points in 3-min
##                         intervals which equals 3360 * 3 / 60 / 24 = 7 days
##                         worth of lagged values are included as predictors)
##           aggr        - number of data points that are aggregated for the 
##                         prediction values (5 equals 15 min aggregation will
##                         be predicted -> 5 * 3-min interval data points)
##           
## Returns:  df          - resulting predictor matrix of dimensions n = "number
##                         of data points between end.train and start.train
##                         devided by aggr" times m = "window.size"



slidingLASSOWindows = function(data,
                               start.train = "2017-01-01 00:00",
                               end.train   = "2017-09-30 23:57",
                               window.size = 3360,
                               aggr        = 5) {
    
    # Load packages
    packages = c("tidyverse")
    invisible(lapply(packages, library, character.only = TRUE))
    
    # Set start and end index of data vector
    start = interval(ymd_hm(201701010000, tz = "CET"),
                     ymd_hm(start.train, tz  = "CET")) / dminutes(3) +
            window.size
    
    end   = interval(ymd_hm(201701010000, tz = "CET"),
                     ymd_hm(end.train, tz    = "CET")) / dminutes(3)
    
    # Define break points in time series
    steps = seq(start, end, by = aggr)
    
    # Keep only numeric vector of values w/o timestamps
    v     = pull(data[, 2])
    
    # Cut time series along break points in "steps" and write into
    # rows of matrix
    df    = matrix(unlist(sapply(steps,
                                 function(x) {
                                     v[(x - (window.size - 1)) : x]})),
                   ncol = window.size,
                   byrow = TRUE)
    
    # Return output
    return(df)
    
}
