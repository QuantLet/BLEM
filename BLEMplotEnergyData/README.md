[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **BLEMplotEnergyData** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml


Name of Quantlet: BLEMplotEnergyData

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Generates plots of energy consumption/production/both time series of energy consumers/prosumers generated from energy readings in 3-minute intervals.

Keywords: energy consumption, energy production, consumer, prosumer, local energy trading, time series graph, energy readings, household, plot

Author: Michael Kostmann

See also:
- BLEMdataGlimpse
- BLEMdescStatEnergyData
- BLEMevaluateEnergyPreds
- BLEMevaluateMarketSim
- BLEMmarketSimulation
- BLEMplotEnergyPreds
- BLEMplotPredErrors
- BLEMpredictLASSO
- BLEMpredictLSTM
- BLEMpredictNaive
- BLEMtuneLSTM
- BLEMplotScalingForLSTM

Submitted:  26.10.2018

Input: 100 consumer and 100 prosumer data sets containing electricity readings in 3-minute intervals (csv-files)

Output: time series graphs of electricity consumption, production or both of specified consumers/prosumers in different adjustable time periods
```

![Picture1](c013_cons.jpg)

![Picture2](c015_cons.jpg)

![Picture3](c021_cons.jpg)

![Picture4](c035_cons.jpg)

![Picture5](c046_cons.jpg)

![Picture6](c053_cons.jpg)

![Picture7](c057_cons.jpg)

![Picture8](c067_cons.jpg)

![Picture9](c070_cons.jpg)

![Picture10](c076_cons.jpg)

![Picture11](c078_cons.jpg)

![Picture12](c080_cons.jpg)

![Picture13](c082_cons.jpg)

![Picture14](c090_cons.jpg)

![Picture15](p004_cons.jpg)

![Picture16](p012_cons.jpg)

![Picture17](p012_prod&cons.jpg)

![Picture18](p015_cons.jpg)

![Picture19](p015_prod&cons.jpg)

![Picture20](p019_cons.jpg)

![Picture21](p019_prod&cons.jpg)

![Picture22](p024_cons.jpg)

![Picture23](p024_prod&cons.jpg)

![Picture24](p026_cons.jpg)

![Picture25](p026_prod&cons.jpg)

![Picture26](p030_cons.jpg)

![Picture27](p030_prod&cons.jpg)

![Picture28](p031_cons.jpg)

![Picture29](p031_prod&cons.jpg)

![Picture30](p038_cons.jpg)

![Picture31](p050_cons.jpg)

![Picture32](p061_cons.jpg)

![Picture33](p072_cons.jpg)

![Picture34](p072_prod&cons.jpg)

![Picture35](p075_cons.jpg)

![Picture36](p075_prod&cons.jpg)

![Picture37](p083_cons.jpg)

![Picture38](p083_prod&cons.jpg)

![Picture39](p084_cons.jpg)

![Picture40](p084_prod&cons.jpg)

![Picture41](p085_cons.jpg)

![Picture42](p085_prod&cons.jpg)

![Picture43](p086_cons.jpg)

![Picture44](p086_prod&cons.jpg)

![Picture45](p089_cons.jpg)

![Picture46](p089_prod&cons.jpg)

![Picture47](p093_cons.jpg)

### R Code
```r



## Plot time series recorded by energy smart meters
## Author: Michael Kostmann


# Set options
options(scipen = 999)

# Load packages
packages  = c("data.table",
              "tidyverse",
              "tidyquant",
              "cowplot",
              "tibbletime")
invisible(lapply(packages, library, character.only = TRUE))

# Load user-defined functions
functions = c("FUN_getData.R")
invisible(lapply(functions, source))

# Function for easy string pasting
"%&%"     = function(x, y) {paste(x, y, sep = "")}



### PLOT ONLY CONSUMPTION VALUES ###

# Specify consumer or prosumer directory
path = "../data/consumer/"
#path = "../data/prosumer/"

# Load data with consumption or production values
data = getData(path,
               data   = "all",
               return = "consumption")
# data = getData(path,
#                data   = "all",
#                return = "production")

# Specify which datasets should be plotted (different options possible,
# options can be adjusted as required):


# a) Plot all consumers
# datasets = colnames(data)[-1]

# b) Plot exemplary consumption time series (5 with large 0 shares + 2 normal)
datasets = c("c013_cons", "c035_cons", "c067_cons", "c070_cons",
              "c076_cons", "c082_cons", "c015_cons", "c090_cons")

# c) Plot consumers with abnormal consumption patterns
# datasets = c("c021_cons", "c046_cons", "c053_cons", "c057_cons",
#              "c067_cons", "c078_cons", "c080_cons")

# d) Plot consumption values of all prosumers with positive total production
# datasets = c("p012_cons", "p015_cons", "p019_cons", "p024_cons", "p026_cons",
#              "p030_cons", "p031_cons", "p072_cons", "p075_cons", "p083_cons",
#              "p084_cons", "p085_cons", "p086_cons", "p089_cons")

# e) Plot consumption values of additional prosumers discussed in thesis
# datasets = c("p004_cons", "p038_cons", "p050_cons", "p061_cons", "p093_cons")

# Specify file format to save plot (.jpg or .pdf)
format <- ".jpg"

# Loop over specified datasets plot and save plots
for(id in datasets) {
    
    p_title1 <- ggdraw() + 
        draw_label("Consumer "%&%substr(id, 2, 4)%&%": Energy consumption",
                   size     = 18,
                   fontface = "bold")
    
    p1 <- data[, c("time", eval(id))] %>%
        rename(value := !!(id)) %>%
        select(time, value) %>%
        
        ggplot(aes(time, value)) +
        geom_line(alpha = 0.75) +
        theme_classic(base_size = 10) +
        ylab("kWh per 3 minutes") +
        xlab("timestamp") +
        labs(title = "Full data (01/01/2017 - 01/01/2018)")
    
    p2 <- data[, c("time", eval(id))] %>%
        rename(value := !!(id)) %>%
        select(time, value) %>%
        filter_time("2017-05-01" ~ "2017-06-01") %>%
        
        ggplot(aes(time, value)) +
        geom_line(alpha = 0.75) +
        theme_classic(base_size = 10) +
        ylab("kWh per 3 minutes") +
        xlab("timestamp") +
        labs(title = "One month (01/05/2017 - 01/06/2017)")
    
    p3 <- data[, c("time", eval(id))] %>%
        rename(value := !!(id)) %>%
        select(time, value) %>%
        filter_time("2017-05-13 00:00:00" ~ "2017-05-13 23:57:00") %>%
        
        ggplot(aes(time, value)) +
        geom_line(alpha = 0.75) +
        theme_classic(base_size = 10) +
        ylab("kWh per 3 minutes") +
        xlab("timestamp") +
        labs(title = "One day (13/05/2017 00:00 - 13/05/2017 23:57)")
    
    plot_grid(p_title1, p1, p2, p3, ncol = 1, rel_heights = c(0.15, 1, 1, 1))
    ggsave(""%&%id%&%format, height = 8.267, width = 11.692)
    
}



### PLOT CONSUMPTION AND PRODUCTION VALUES IN ONE GRAPH ###

# Specify consumer or prosumer directory
path = "../data/prosumer/"

# Load data with consumption or production values
data_cons = getData(path, data = "all", return = "consumption")
data_prod = getData(path, data = "all", return = "production")

# Specify which datasets should be plotted (adjust as required):
datasets_cp = c("p012_prod", "p015_prod", "p019_prod", "p024_prod", "p026_prod",
                "p030_prod", "p031_prod", "p072_prod", "p075_prod", "p083_prod",
                "p084_prod", "p085_prod", "p086_prod", "p089_prod")

# Specify file format to save plot (.jpg or .pdf)
format <- ".jpg"

# Loop over specified datasets plot and save plots
for(id in datasets_cp) {
    p_title4 <- ggdraw() + 
        draw_label("Prosumer "%&%substr(id, 2, 4)%&%
                   ": Net energy production and consumption",
                   size     = 18,
                   fontface = "bold")
    
    p5 <- data_prod[, c("time", eval(id))] %>%
        rename(prod := !!(id)) %>%
        select(time, prod) %>%
        
        ggplot(aes(x      = time,
                   y      = prod,
                   colour = "net production")) +
        geom_line(alpha = 0.75) +
        geom_line(data = data_cons,
                  aes_string("time",
                             eval(gsub("prod", "cons", eval(id))),
                             color = '"net consumption"')) +
        scale_colour_manual("",
                            breaks = c("net production", "net consumption"),
                            values = c("darkblue", "red")) +
        theme_classic(base_size = 10) +
        ylab("kWh per 3 minutes") +
        xlab("timestamp") +
        labs(title = "Full data (01/01/2017 - 01/01/2018)")
    
    p6 <- data_prod[, c("time", eval(id))] %>%
        rename(prod := !!(id)) %>%
        select(time, prod) %>%
        filter_time("2017-05-01" ~ "2017-06-01") %>%
        
        ggplot(aes(x      = time,
                   y      = prod,
                   colour = "net production")) +
        geom_line(alpha = 0.75) +
        geom_line(data = data_cons %>%
                      filter_time("2017-05-01" ~ "2017-06-01"),
                  aes_string("time",
                             eval(gsub("prod", "cons", eval(id))),
                             color = '"net consumption"')) +
        scale_colour_manual("",
                            breaks = c("net production", "net consumption"),
                            values = c("darkblue", "red")) +
        theme_classic(base_size = 10) +
        ylab("kWh per 3 minutes") +
        xlab("timestamp") +
        labs(title = "One month (01/05/2017 - 01/06/2017)")
    
    p7 <- data_prod[, c("time", eval(id))] %>%
        rename(prod := !!(id)) %>%
        select(time, prod) %>%
        filter_time("2017-05-13 00:00:00" ~ "2017-05-13 23:57:00") %>%
        
        ggplot(aes(x      = time,
                   y      = prod,
                   colour = "net production")) +
        geom_line(alpha = 0.75) +
        geom_line(data = data_cons %>% 
                      filter_time("2017-05-13 00:00:00" ~ "2017-05-13 23:57:00") ,
                  aes_string("time",
                             eval(gsub("prod", "cons", eval(id))),
                             colour = '"net consumption"')) +
        scale_colour_manual("",
                            breaks = c("net production", "net consumption"),
                            values = c("darkblue", "red")) +
        theme_classic(base_size = 10) +
        ylab("kWh per 3 minutes") +
        xlab("timestamp") +
        labs(title = "One day (13/05/2017 00:00 - 13/05/2017 23:57)")
    
    plot_grid(p_title4, p5, p6, p7, ncol = 1, rel_heights = c(0.15, 1, 1, 1))
    ggsave(""%&%id%&%"&cons"%&%format, height = 8.267, width = 11.692)
}


## end of file ##

```

automatically created on 2018-10-26