

## Function: getData
## Author: Michael Kostmann

## Args:     path          - path of the directory that contains the datasets of
##                           consumers or prosumers that should be read in
##           id            - specifies consumer or prosumer dataset that should be
##                           read. Must be of the form "consumer-00000001" or
##                           "producer-00000001".
##           return        - which values to return in the data frame. Arguments are
##                           "consumption" (first-order difference of energy),
##                           "energy", "energyOut", and "production" (first-order
##                           difference of energyOut)
##           min_test_time - start date and time of testing data
##           max_test_time - end date and time of testing data
##           
## Returns:  targets       - numeric vector of values specified in "return" aggregated
##                           to 15-min intervalls for the specified testing data period



getTargets  = function(path,
                       id,
                       return = "consumption",
                       min    = "2017-10-01 00:03:00",
                       max    = "2018-01-01 00:00:00"){
    
    # Source user-defined function
    source("FUN_getData.R")
    
    # Get data
    temp    = getData(path,
                      data = "single",
                      id,
                      return)
    
    # Aggregate data to 15-min intervals and strip timestamps
    targets = temp %>%
        filter_time(min ~ max) %>%
        mutate(time_aggr = 
                   collapse_index(index = time,
                                  period = "15 minutely",
                                  side = "end",
                                  start_date = as_datetime(min(time),
                                                           tz = "CET"))) %>%
        group_by(time_aggr) %>%
        summarise(targets = sum(!!sym(colnames(temp)[2]))) %>%
        pull(targets)
    
    # Correct last aggregation value
    targets[(length(targets)-1)] = targets[(length(targets)-1)] + targets[length(targets)]
    targets                      = targets[-length(targets)]
    
    return(targets)
    
}
