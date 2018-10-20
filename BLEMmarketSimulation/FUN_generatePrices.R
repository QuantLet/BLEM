

## Function: generatePrices (zero-intelligence prices; random in interval)
## Author: Michael Kostmann


## Args:     amounts    - matrix of amounts demanded or supplied per market
##                        participant (cols) and trading period (rows)
##           min_price  - lower price bound (outside option for sellers)
##           max_price  - upper price bound (outside option for buyers)
##           seed       - single integer that can be supplied to
##                        base::set.seed()
##       
## Returns:  p          - matrix with prices for each market agent and
##                        trading period



generatePrices = function(amounts,
                           min_price,
                           max_price,
                           seed = NULL) {
    
    # Set seed if supplied
    if(!is.null(seed)) {set.seed(seed)}
    
    # Number of trading periods and number of market participants
    m = nrow(amounts)
    n = ncol(amounts)
    
    # Initialize matrix
    p = matrix(NA, nrow = m, ncol = n)
    
    # Fill matrix with prices drawn from uniform discrete distribution
    # in 0.01 steps
    p[amounts != 0] = round(sample(seq(min_price,
                                       max_price,
                                       by = 0.01),
                                   sum(amounts!=0),
                                   replace = TRUE),
                            digits = 2)
    
    # If amount is "0", set price to 0 as well
    p[is.na(p)] = 0
    
    # Return price matrix
    return(p)
}
