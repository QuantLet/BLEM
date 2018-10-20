

## Generate market outcomes with true and predicted values
## Author: Michael Kostmann


# Source user-defined functions
functions = c("FUN_getTargets.R",
              "FUN_generatePrices.R",
              "FUN_blindAuction.R")
invisible(lapply(functions, source))



###  Market simulation with true values  ###

# Specify paths to directories containing consumer and prosumer datasets
path_c  = "data/consumer/"
path_p  = "data/prosumer/"

# Specify which datasets from directories should be loaded for market analysis
files_c = substring(list.files(path_c,
                                pattern = "*.csv"),
                     1, 17)[-c(13, 21, 26, 35, 46, 53, 57, 67, 76, 78, 80, 81)]

# Balanced supply and demand
files_p = substring(list.files(path_p, pattern = "*.csv"),
                     1, 17)[c(19, 24, 26, 30, 72, 75, 89)] #, 31, 86, 83, 84, 85

# Oversupply
# files_p = substring(list.files(path_p, pattern = "*.csv"),
#                      1, 17)[c(19, 24, 26, 30, 72, 75, 83, 84, 89)] #, 31, 86, 85

# Undersupply
# files_p = substring(list.files(path_p, pattern = "*.csv"),
#                      1, 17)[c(19, 24, 26, 72, 75, 89)] # 30, 31, 86,  83, 84, 85


# Load consumption data per 15-minute time interval
cons = matrix(NA, nrow = 8836, ncol = (length(files_c)))
i = 0

for(id in files_c) {
    i = i+1
    cons[, i] = getTargets(path   = path_c,
                           id     = id,
                           return = "consumption",
                           min    = "2017-10-01 00:00",
                           max    = "2018-01-01 00:00")
}

# Load net production data per 15-minute time interval
prod = matrix(NA, nrow = 8836, ncol = length(files_p))
i = 0

for(id in files_p) {
    i = i+1
    prod[, i] = getTargets(path   = path_p,
                           id     = id,
                           return = "production",
                           min    = "2017-10-01 00:00",
                           max    = "2018-01-01 00:00")
}

# Generate prices
bid_prices = generatePrices(cons,
                             min_price = 12.31,
                             max_price = 28.69,
                             seed      = 20181005)

ask_prices = generatePrices(prod,
                             min_price = 12.31,
                             max_price = 28.69,
                             seed      = 20181005)

# Compuate market outcomes
market_outcomes_true = list()
pb = txtProgressBar(min = 0, max = nrow(cons), style = 3)

for(i in 1:nrow(cons)){
    market_outcomes_true[[i]] = blindAuction(cons_amount = cons[i, ],
                                             prod_amount = prod[i, ],
                                             max_price   = 28.69,
                                             min_price   = 12.31,
                                             bid_prices  = bid_prices[i, ],
                                             ask_prices  = ask_prices[i, ])
    setTxtProgressBar(pb, i)
}

# Save market outcomes
save(market_outcomes_true, file = "market_outcomes/true_outcomes_balanced.RData")
#save(market_outcomes_true, file = "market_outcomes/true_outcomes_oversupply.RData")
#save(market_outcomes_true, file = "market_outcomes/true_outcomes_undersupply.RData")



###  Market simulation with predicted values  ###

# Define vector of datasets to exclude from error analysis
remove   = c(13, 21, 34, 45, 52, 56, 66, 75, 77, 79, 81)

# Load predicted consumption values
cons_pred_all = read.csv("predictions/LASSO_predictions.csv")[, -1]
cons_pred     = cons_pred_all[, -remove]

# Compuate market outcomes
market_outcomes_pred = list()
pb = txtProgressBar(min = 0, max = nrow(cons_pred), style = 3)

for(i in 1:nrow(cons_pred)){
    market_outcomes_pred[[i]] = blindAuction(cons_amount = cons_pred[i, ],
                                             prod_amount = prod[i, ],
                                             max_price   = 28.69,
                                             min_price   = 12.31,
                                             bid_prices  = bid_prices[i, ],
                                             ask_prices  = ask_prices[i, ])
    setTxtProgressBar(pb, i)
}

# Save market outcomes
save(market_outcomes_pred, file = "market_outcomes/pred_outcomes_balanced.RData")
#save(market_outcomes_pred, file = "market_outcomes/pred_outcomes_oversupply.RData")
#save(market_outcomes_pred, file = "market_outcomes/pred_outcomes_undersupply.RData")


## end of file ##
