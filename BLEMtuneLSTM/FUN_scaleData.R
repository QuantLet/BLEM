

## Function: scaleData
## Author: Michael Kostmann


## Args:     data     - time tibble with time series data
##           option   - what kind of transformation should be applied to the
##                      data: "normalize" (scale between 0 and 1), "log-
##                      normalize" (normalize log-values), "unscale" (revert
##                      "normalize"), "unscale_log" (revert "log-normalize").
##                      For "unscale" and "unscale_log", "min" and "max" must
##                      be specified.
##           min, max - min, max values of training data. Can be set manually.
##                      Also returned when using "normalize" or "log-normalize"
##           time.tbl - if TRUE, output is time tibble; if FALSE, output is
##                      numeric matrix or vector
##           
## Returns:  out      - depending on the arg "out" time tibble or numeric
##                      matrix with transformed values


scaleData = function(data,
                     option   = "normalize",
                     split    = "2017-10-01 00:00",
                     min      = NULL,
                     max      = NULL,
                     time.tbl = TRUE) {
    
    # Load packages
    packages = c("tidyverse", "tibbletime", "rlang", "lubridate")
    invisible(lapply(packages, library, character.only = TRUE))
    
    # Identify column with time index
    idx_col = which(colnames(data) == get_expr(attributes(data)$index_quo))
    
    # Drop time index column
    x = data[, -idx_col]
    
    # Get split index
    split_idx = interval(ymd_hm(201701010000, tz = "CET"),
                         ymd_hm(split, tz = "CET"))/dminutes(3)
    
    # Set min and max of training data
    if(option == "normalize"){
        min = apply(x, 2, function(x) {min(x[1:split_idx])})
        max = apply(x, 2, function(x) {max(x[1:split_idx])})  
    }
    
    if(option == "log-normalize"){
        min_log = apply(x, 2, function(x) {
            log_x = log(x[x != 0])
            min(log_x)
        })
        
        max_log = apply(x, 2, function(x) {
            log_x = log(x[x != 0])
            max(log_x)
        }) 
    }
    
    # Scale data: normalize between 0 and 1, normalize log-values between 0
    # and 1, reverse scaling of both options
    switch(option,
           "normalize"     = out <- apply(x, 2, function(x) {
               (x - min) / (max - min)}),
           
           "log-normalize" = out <- apply(x, 2, function(x) {
               x[x != 0] = log(x[x != 0])
               (x - min_log) / (max_log - min_log)
           }),
           
           "unscale"       = out <- apply(x, 2, function(x) {
               x * (max - min) + min
           }),
           
           "unscale_log"   = out <- apply(x, 2, function(x) {
               x[x !=0 ] = exp(x[x != 0])
               x * (max - min) + min
           })
    )
    
    # Bind index to out data
    if(time.tbl == TRUE) {
        out = cbind(data[, idx_col], out) %>%
            as_tbl_time(index = time)
    }
    
    # Return transformed data
    switch(option,
           "normalize"     = return(list("data" = out,
                                         "min"  = min,
                                         "max"  = max)),
           "log-normalize" = return(list("data" = out,
                                         "min"  = min_log,
                                         "max"  = max_log)),
           "unscale"       = return(out),
           "unscale_log"   = return(out)
    )
}

