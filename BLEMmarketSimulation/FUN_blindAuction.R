

## Function: blindAuction
## Author: Michael Kostmann


## Args:     cons_amount  - numeric vector containing electricity consumption 
##                          of current trading period for each electricity
##                          consuming market participant
##           prod_amount  - numeric vector containing electricity production 
##                          of current trading period for each electricity
##                          producing market participant
##           min_price    - lower price boundary for possible bids and asks
##                          (outside option for electricity selling)
##           max_price    - upper price boundary for possible bids and asks
##                          (outside option for electricity buying)
##           bid_prices   - numeric vector containing bid prices in EURct/kWh
##                          for which consuming market participants are willing
##                          to buy electricity amount specified in cons_amount
##           ask_prices   - numeric vector containing ask prices in EURct/kWh
##                          for which producing market participants are willing
##                          to sell electricity amount specified in prod_amount
##       
## Returns:  for current trading period a nested list with
## 
##             - eq_price:   equilibrium price - the highest price
##                           which can still be served given the
##                           amounts offered by producers 
##             - LEM_price:  local energy market price - average
##                           of equilibrium price and max_price
##                           weighted by kWh amounts traded at the
##                           respective price
##             - bid_results:
##                  - ID:         numerical vector with consumer IDs
##                  - amount:     numerical vector with amounts specified by
##                                bidders (cons_amount)
##                  - price_bid:  numerical vector with prices bid (bid_prices)
##                  - price_paid: numerical vector with equilibrium price or 
##                                max_price for each consumer depending on
##                                auction outcome
##                  - cost:       numerical vector with amount in EURct paid by
##                                each consumer
##             - asks_results:
##                  - ID:             numerical vector with producer IDs
##                  - amount:         numerical vector with amounts specified
##                                    by sellers (prod_amount)
##                  - price_asked:    numerical vector with prices asked
##                                    (ask_prices)
##                  - price_received: numerical vector with equilibrium price
##                                    or min_price for each producer depending
##                                    on auction outcome
##                  - revenue:        numerical vector with amount in EURct
##                                    received by each producer
##             - supply:     total amount of electricity supplied in trading
##                           period
##             - demand:     total amount of electricity demanded in trading
##                           period
##             - oversupply: difference between total supply and total demand



blindAuction = function(cons_amount,
                        prod_amount,
                        min_price = 12.31,
                        max_price = 28.69,
                        bid_prices,
                        ask_prices) {
    
    # Generate bids
    bids = data.frame(ID           = c(1:length(cons_amount)),
                       amount      = as.vector(cons_amount, mode = "numeric"),
                       price_bid   = bid_prices)
    
    # Generate asks
    asks = data.frame(ID           = c(1:length(prod_amount)),
                       amount      = prod_amount,
                       price_asked = ask_prices)
    
    # Supply, demand, and oversupply
    supply     = sum(asks$amount)
    demand     = sum(bids$amount)
    oversupply = supply - demand
    
    # Ordered lists of bids (decreasing) and asks (increasing)
    bids_ordered = bids[order(bids$price_bid, decreasing = TRUE), ]
    asks_ordered = asks[order(asks$price_asked, decreasing = FALSE), ]
    
    # If total supply < total demand
    if(sum(prod_amount) < sum(cons_amount)) {
        
        total_prod_amount = sum(prod_amount)

        if(length(bids_ordered[cumsum(bids_ordered$amount) <=
                               total_prod_amount, "ID"]) > 0) {
            # Identify bid that can still be served given the total supply
            idx   = nrow(bids_ordered[cumsum(bids_ordered$amount) <=
                                          total_prod_amount, ])
            eq_ID = bids_ordered[idx, "ID"]
            
            # Identified bid gives equilibrium price
            eq_price = bids[eq_ID, "price_bid"][1]
            
            # IDs of orders that pay eq_price
            IDs_eq_price  = bids_ordered[1:idx, "ID"]
            
            # IDs of orders that pay max_price
            IDs_max_price = bids_ordered[(idx + 1):nrow(bids_ordered), "ID"]
            
            # Price paid for each bid
            price_paid                = vector(mode   = "numeric",
                                               length = nrow(bids))
            price_paid[IDs_eq_price]  = eq_price
            price_paid[IDs_max_price] = max_price
            
            bids                      = data.frame(bids,
                                                   "price_paid" = price_paid)
            
            # Amounts buyers pay
            transfer_buyer = vector(mode   = "numeric",
                                    length = length(cons_amount))
            transfer_buyer[bids$price_bid >= eq_price] =
                bids[bids$price_bid >= eq_price, "amount"] * eq_price
            transfer_buyer[bids$price_bid < eq_price]  =
                bids[bids$price_bid < eq_price, "amount"] * max_price
            
            bids = data.frame(bids, "cost" = transfer_buyer)
            
            # Price received for each ask
            asks = data.frame(asks, "price_recieved" = eq_price)
            
            # Amounts sellers receive
            transfer_seller = asks$amount * eq_price
            
            asks            = data.frame(asks, "revenue" = transfer_seller)
            
        } else {
            # Only first bid can be partially served with produced amount
            eq_ID    = bids_ordered[1, "ID"]
            
            # First bid gives equilibrium price
            eq_price = bids[eq_ID, "price_bid"][1]
            
            # Price paid for each bid
            price_paid         = vector(mode   = "numeric",
                                        length = nrow(bids))
            price_paid[eq_ID]  = eq_price
            price_paid[-eq_ID] = max_price
            
            bids = data.frame(bids, "price_paid" = price_paid)
            
            # Amounts buyers pay
            transfer_buyer = vector(mode   = "numeric",
                                    length = length(cons_amount))
            
            transfer_buyer[eq_ID] = total_prod_amount * eq_price +
                (bids[eq_ID, "amount"] - total_prod_amount) * max_price
            
            transfer_buyer[bids$price_bid < eq_price] =
                bids[bids$price_bid < eq_price, "amount"] * max_price
            
            bids = data.frame(bids, "cost" = transfer_buyer)
            
            # Price received for each ask
            asks = data.frame(asks, "price_recieved" = eq_price)
            
            # Amounts sellers receive
            transfer_seller = asks$amount * eq_price
            
            asks            = data.frame(asks, "revenue" = transfer_seller)
        }
    }
    
    # If total supply > total demand
    if(sum(prod_amount) >= sum(cons_amount)) {
        
        # Identify lowest bid price
        eq_ID = bids_ordered[which(
            bids_ordered$price_bid ==
                min(bids$price_bid[bids$price_bid != 0])),
            "ID"]
        
        # Lowest bid gives equilibrium price
        eq_price = bids[eq_ID, "price_bid"][1]
        
        # Price paid for each bid
        bids = data.frame(bids, "price_paid" = rep(eq_price, nrow(bids)))
        
        # Amounts buyers pay
        transfer_buyer = bids$amount * eq_price
        
        bids = data.frame(bids, "cost" = transfer_buyer)
        
        # Price received for each ask
        price_received = vector(mode   = "numeric",
                                length = nrow(asks))
        
        price_received[asks$price_asked < eq_price] = eq_price
        price_received[asks$price_asked > eq_price] = min_price
        
        asks = data.frame(asks, "price_received" = price_received)
        
        # Transfers sellers receive
        transfer_seller = vector(mode   = "numeric",
                                 length = length(prod_amount))
        
        transfer_seller[asks$price_asked < eq_price] =
            asks[asks$price_asked < eq_price, "amount"] * eq_price
        
        transfer_seller[asks$price_asked > eq_price] =
            asks[asks$price_asked > eq_price, "amount"] * min_price
        
        asks = data.frame(asks, "revenue" = transfer_seller)
        
    }
    
    return(list("eq_price"     = eq_price,
                "LEM_price"    = with(bids, sum(amount*price_paid)/sum(amount)),
                "bid_results"  = bids,
                "asks_results" = asks,
                "supply"       = supply,
                "demand"       = demand,
                "oversupply"   = oversupply))
}

