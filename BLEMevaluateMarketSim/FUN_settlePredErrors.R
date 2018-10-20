

## Function: settlePredErrors


## Args:     error            - matrix containing prediction errors for each
##                              consumer in each trading period
##           min_price        - lower price bound (outside option for sellers)
##           max_price        - upper price bound (outside option for buyers)
##       
## Returns:  cost_correction  - matrix with correction amounts in EURct to
##                              settle differences between predicted and actual
##                              consumption values



settlePredErrors = function(error, min_price, max_price) {
    
    # Function to get ceiling on two digit decimals
    ceiling_dec = function(x, level=2) round(x + 5*10^(-level-1), level)
    
    # Initiate matrix
    cost_correction = matrix(NA, nrow = nrow(error), ncol = ncol(error))
    
    # Positive prediction error has to sell surplus of order to grid at min price
    cost_correction[error > 0]  = ceiling_dec(error[error > 0] * min_price)
    
    # Negative prediction error has to buy deficit from grid at max price
    cost_correction[error < 0]  = ceiling_dec(error[error < 0] * max_price)
    
    # No prediction error
    cost_correction[error == 0] = 0
    
    # Return results
    return(cost_correction)
}
