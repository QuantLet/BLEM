

## Plot oversupply and prices of market simulation


# Clear global environment
rm(list=ls())

# Load packages
packages  = c("cowplot")
invisible(lapply(packages, library, character.only = TRUE))

# Function for easy string pasting
"%&%"     = function(x, y) {paste(x, y, sep = "")}

# Set vector
scenarios = c("_balanced", "_oversupply", "_undersupply")
captions  = c("Balanced supply", "Oversupply", "Undersuppy")

# Index for captions
c = 0

for(i in scenarios){
    
    # Load market outcomes
    load("market_outcomes/true_outcomes"%&%i%&%".RData")
    load("market_outcomes/pred_outcomes"%&%i%&%".RData")
    
    
    ## Market outcomes with true values ##
    
    # Extract oversupply and prices per period
    data_true = data.frame("time"       = 
                               seq.POSIXt(as.POSIXct("2017-10-01 00:00"),
                                          as.POSIXct("2018-01-01 00:00"),
                                          by = 900)[1:8836], 
                            "oversupply" = 
                               map_dbl(market_outcomes_true, "oversupply"),
                            "eq_price"   = 
                               map_dbl(market_outcomes_true, "eq_price"),
                            "LEM_price"  = 
                               map_dbl(market_outcomes_true, "LEM_price"))
    
    # Extract supply, demand, and equilibrium prices per period
    supply_true   = map_dbl(market_outcomes_true, "supply")
    demand_true   = map_dbl(market_outcomes_true, "demand")
    eq_price_true = map_dbl(market_outcomes_true, "eq_price")
    
    # Plot oversupply, equilibrium and weighted average prices
    c = c+1
    ptitle = ggdraw() +
        draw_label(captions[c]%&%": Market outcomes per trading period"%&%
                       "with true consumption values",
                   size     = 16,
                   fontface = "bold")
    
    p1 = data_true %>%
        ggplot() +
        geom_line(aes(x = time, y = oversupply)) +
        geom_hline(yintercept = 0, col = "red") +
        ylab("Oversupply in kWh") +
        xlab("Timestamp") +
        theme_classic(base_size = 10)
    
    p2 = data_true %>%
        ggplot() +
        geom_line(aes(x = time, y = eq_price)) +
        geom_hline(yintercept = 12.31, col = "red") +
        geom_hline(yintercept = 28.69, col = "red") +
        ylab("Equilibrium price in EURct") +
        xlab("Timestamp") +
        theme_classic(base_size = 10)
    
    p3 = data_true %>%
        ggplot() +
        geom_line(aes(x = time, y = LEM_price)) +
        geom_hline(yintercept = 12.31, col = "red") +
        geom_hline(yintercept = 28.69, col = "red") +
        ylab("LEM price in EURct") +
        xlab("Timestamp") +
        theme_classic(base_size = 10)
    
    plot_grid(ptitle, p1, p2, p3, ncol = 1, rel_heights = c(0.15, 1, 1, 1))
    ggsave("graphs/marketoutcome_true"%&%i%&%".pdf",
           height = 8.267, width = 11.692)
    
    
    
    ## Market outcomes with predicted values ##
    
    # Extract oversupply and prices per period
    data_pred = data.frame("time"       = 
                               seq.POSIXt(as.POSIXct("2017-10-01 00:00"),
                                          as.POSIXct("2018-01-01 00:00"),
                                          by = 900)[1:8836],
                            "oversupply" = 
                               map_dbl(market_outcomes_pred, "oversupply"),
                            "eq_price"   =
                               map_dbl(market_outcomes_pred, "eq_price"),
                            "LEM_price"  =
                               map_dbl(market_outcomes_pred, "LEM_price"))
    
    # Extract supply, demand, and equilibrium prices per period
    supply_predb  = map_dbl(market_outcomes_pred, "supply")
    demand_pred   = map_dbl(market_outcomes_pred, "demand")
    eq_price_pred = map_dbl(market_outcomes_pred, "eq_price")
    
    # Plot oversupply, equilibrium and weighted average prices
    ptitle = ggdraw() +
        draw_label(captions[c],
                   size     = 16,
                   fontface = "bold")
    
    p1 = data_pred %>%
        ggplot() +
        geom_line(aes(x = time, y = oversupply)) +
        geom_hline(yintercept = 0, col = "red") +
        ylab("Oversupply in kWh") +
        xlab("Timestamp") +
        theme_classic(base_size = 10)
    
    p2 = data_pred %>%
        ggplot() +
        geom_line(aes(x = time, y = eq_price)) +
        geom_hline(yintercept = 12.31, col = "red") +
        geom_hline(yintercept = 28.69, col = "red") +
        ylab("Equilibrium price in EURct") +
        xlab("Timestamp") +
        theme_classic(base_size = 10)
    
    p3 = data_pred %>%
        ggplot() +
        geom_line(aes(x = time, y = LEM_price)) +
        geom_hline(yintercept = 12.31, col = "red") +
        geom_hline(yintercept = 28.69, col = "red") +
        ylab("LEM price in EURct") +
        xlab("Timestamp") +
        theme_classic(base_size = 10)
    
    plot_grid(ptitle, p1, p2, p3, ncol = 1, rel_heights = c(0.15, 1, 1, 1))
    ggsave("graphs/marketoutcome_pred"%&%i%&%".pdf",
           height = 8.267, width = 11.692)
    
}


## end of file ##
