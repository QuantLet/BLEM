

## Descriptive statistics of consumer and prosumer datasets
## Author: Michael Kostmann


# Load packages
packages  = c("tidyverse",
              "tidyquant",
              "cowplot",
              "tibbletime")
invisible(lapply(packages, library, character.only = TRUE))

# Load user-defined functions
functions = c("FUN_getData.R")
invisible(lapply(functions, source))

# Function for easy string pasting
"%&%"     = function(x, y) {paste(x, y, sep = "")}

# Set display options
options(scipen = 999)



### CONSUMER ###


# Load data with consumption or production values
data_cons = getData(path   ="../data/consumer/",
                    data   = "all",
                    return = "consumption")


# Compute median and mean consumption of all consumers
medians_c   = apply(as.matrix(data_cons[, -1]), 2, median)
means_c     = apply(as.matrix(data_cons[, -1]), 2, mean)

# Compute standard deviation of all consumers
stdevs_c    = apply(as.matrix(data_cons[, -1]), 2, sd)

# Compute yearly energy consumption of consumers
total_c     = apply(as.matrix(data_cons[, -1]), 2, sum)

summary(total_c, round = 1)
stats_table = matrix(summary(total_c), nrow = 1)

cumsum(total_c[order(total_c, decreasing = TRUE)]/sum(total_c)*100)
which(total_c[order(total_c, decreasing = TRUE)] == total_c["c082_cons"])


## Barplot

# Plot distribution of total consumption
id_cons    = gsub(".*?([0]{5})([0-9]{3}).*", "c\\2",
                  list.files(path    = "../data/consumer/",
                             pattern = "*.csv"))[-26]

df_total_c = data.frame(total_c, id_cons)

p_title    = ggdraw() + 
    draw_label("Consumers' total energy consumption in 2017",
               size = 18,
               fontface = "bold")

p          = df_total_c %>%
    ggplot(aes(reorder(id_cons, -total_c),
               total_c)) +
    geom_col() +
    theme_classic(base_size = 12) +
    theme(axis.text.x = element_text(angle = 90,
                                     vjust = 0.5)) +
    ylab("kWh") +
    xlab("consumer ID")

plot_grid(p_title, p, ncol = 1, rel_heights = c(0.15, 1))
ggsave("consumer_totalconsumption.jpg",
       height = 8.267/2, width = 11.692)

# Share of zero consumption measurements
table(round(apply(data_cons[, -1], 2,
                  function(x) {sum(x == 0)}) / 175200 * 100,
      digits = 4))
## c013, c035, c067, (c070), c076, c082


## Boxplots

# Order consumers by median consumption
data_cons_ord = data_cons[, c(1, order(medians_c)+1)]
id_cons_ord   = id_cons[order(medians_c)]

# Reshape ordered data frame into long format
data_cons_long = data_cons_ord %>%
    melt(id.vars       = "time",
         variable.name = "consumers")

# Plot boxplots of all consumers in one graph
p_title1 = ggdraw() + 
    draw_label("Distribution of energy consumption per consumers",
               size     = 16,
               fontface = "bold")

p1 = data_cons_long %>%
    ggplot(aes(consumers,
               value)) +
    geom_boxplot() +
    theme_classic(base_size = 12) +
    scale_x_discrete(labels = id_cons_ord) + 
    theme(axis.text.x = element_text(angle = 90,
                                     vjust = 0.5)) +
    ylab("kWh per 3 minutes") +
    xlab("consumer ID")

plot_grid(p_title1, p1, ncol = 1, rel_heights = c(0.15, 1))
ggsave("consumer_boxplots_consumption.jpg",
       height = 8.267, width = 11.692)

# Needed as break as ggsave otherwise corrupts the follwoing function
Sys.sleep(0.1)


### PROSUMER ###


### Consumption

# Load data with consumption or production values
data_pros_c  = getData(path   = "../data/prosumer/",
                       data   = "all",
                       return = "consumption")


# Compute median and mean consumption of all prosumers
medians_pc   = apply(as.matrix(data_pros_c[, -1]), 2, median)
means_pc     = apply(as.matrix(data_pros_c[, -1]), 2, mean)

# Compute standard deviation of all prosumers
stdevs_pc    = apply(as.matrix(data_pros_c[, -1]), 2, sd)

# Compute yearly energy consumption of prosumers
total_pros_c = apply(as.matrix(data_pros_c[, -1]), 2, sum)

summary(total_pros_c)
stats_table  = rbind(stats_table, summary(total_pros_c))

total_pros_c[order(total_pros_c, decreasing = TRUE)]


## Barplot

# Plot distribution of total consumption
id_pros         = gsub(".*?([0]{5})([0-9]{3}).*", "p\\2",
                       list.files(path    = "../data/prosumer/",
                                  pattern = "*.csv"))

df_total_pros_c = data.frame(total_pros_c, id_pros)

p_title2        = ggdraw() + 
    draw_label("Prosumers' total energy consumption in 2017",
               size     = 18,
               fontface = "bold")

p2              = df_total_pros_c %>%
    ggplot(aes(reorder(id_pros, -total_pros_c),
               total_pros_c)) +
    geom_col() +
    theme_classic(base_size = 12) +
    theme(axis.text.x = element_text(angle = 90,
                                     vjust = 0.5)) +
    ylab("kWh") +
    xlab("prosumer ID")

plot_grid(p_title2, p2, ncol = 1, rel_heights = c(0.15, 1))
ggsave("prosumer_totalconsumption.jpg",
       height = 8.267/2, width = 11.692)

# Share of zero consumption measurements
table(round(apply(data_pros_c[, -1], 2,
                  function(x) {sum(x == 0)}) / 175200 * 100,
            digits = 4))


## Boxplots

# Order consumers by median consumption
data_pros_c_ord  = data_pros_c[, c(1, order(medians_pc)+1)]
id_pros_ord      = id_pros[order(medians_pc)]

# Reshape ordered data frame into long format
data_pros_c_long = data_pros_c_ord %>%
    melt(id.vars       = "time",
         variable.name = "prosumers")

# Plot boxplots of all consumers in one graph
p_title2 = ggdraw() + 
    draw_label("Distribution of net energy consumption per prosumer",
               size     = 16,
               fontface = "bold")

p2       = data_pros_c_long %>%
    ggplot(aes(prosumers,
               value)) +
    geom_boxplot() +
    theme_classic(base_size = 12) +
    scale_x_discrete(labels = id_pros_ord) + 
    theme(axis.text.x = element_text(angle = 90,
                                     vjust = 0.5)) +
    ylab("kWh per 3 minutes") +
    xlab("prosumer ID")

plot_grid(p_title2, p2, ncol = 1, rel_heights = c(0.15, 1))
ggsave("prosumer_boxplots_consumption.jpg",
       height = 8.267, width = 11.692)

# Needed as break as ggsave otherwise corrupts the follwoing function
Sys.sleep(0.1)



### Production

# Load data with consumption or production values
data_pros_p  = getData(path   = "../data/prosumer/",
                       data   = "all",
                       return = "production")


# Compute median and mean production of all prosumers
medians_pp   = apply(as.matrix(data_pros_p[, -1]), 2, median)
means_pp     = apply(as.matrix(data_pros_p[, -1]), 2, mean)

# Compute standard deviation of all prosumers
stdevs_pp    = apply(as.matrix(data_pros_p[, -1]), 2, sd)

# Compute yearly energy consumption of prosumers
total_pros_p = apply(as.matrix(data_pros_p[, -1]), 2, sum)

summary(total_pros_p)
stats_table  = rbind(stats_table, summary(total_pros_p))

table(total_pros_p)

# Plot distribution of total production
id              = gsub(".*?([0]{5})([0-9]{3}).*", "p\\2",
                       list.files(path    = "../data/prosumer/",
                                  pattern = "*.csv"))

df_total_pros_p = data.frame(total_pros_p, id)

p_title3        = ggdraw() + 
    draw_label("Prosumers' total energy production in 2017", size = 18,
               fontface = "bold")

p4              = df_total_pros_p %>%
    ggplot(aes(reorder(id, -total_pros_p),
               total_pros_p)) +
    geom_col() +
    theme_classic(base_size = 12) +
    theme(axis.text.x = element_text(angle = 90,
                                     vjust = 0.5)) +
    ylab("kWh") +
    xlab("prosumer ID")

plot_grid(p_title3, p4, ncol = 1, rel_heights = c(0.15, 1))
ggsave("prosumer_totalproduction.jpg",
       height = 8.267/2, width = 11.692)

# Save table with summary statistics
stats_table_out = data.frame("X1" = c("Consumer: consumption",
                                      "Prosumer: consumption",
                                      "Prosumer: production"),
                              stats_table)

write.csv(stats_table_out, "summarystats_total.csv")


## end of file ##
