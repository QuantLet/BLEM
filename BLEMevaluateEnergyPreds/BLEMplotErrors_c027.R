

## Plot relative squared errors of consumer 027
## Author: Michael Kostmann


# Load user-defined functions
packages = c("cowplot")
invisible(lapply(packages, library, character.only = TRUE))

# Load user-defined functions
functions = c("FUN_getTargets.R")
invisible(lapply(functions, source))

# Options
options(scipen = 999)

# Set parameters
path            = "data/consumer/"

# Load prediction dataset
predictions_all = read.csv("predictions/consumer/LSTM_predictions.csv")

# Get index vector with relevant datasets
files           = substring(list.files(path,
                                       pattern = ".csv"),
                            1, 17)

# Retrieve predictions
predictions = predictions_all[, 27]

# Get true values
targets = getTargets(path = path,
                      id  = "consumer-00000027",
                      min = "2017-10-01 00:03",
                      max = "2018-01-01 00:00")[1:length(predictions)]

# Generate dataframe
n    = length(predictions)
data = data.frame("time"   = seq.POSIXt(as.POSIXct("2017-10-01 00:00"),
                                        as.POSIXct("2018-01-01 00:00"),
                                        by = 900)[2:(n+1)],
                   "value" = ((predictions - targets[1:n]) / targets[1:n])^2)
                   
# Plot
p_title = ggdraw() + 
    draw_label(paste0("Squared relative errors of LSTM predictions",
                      " on consumer 027's energy consumption data"),
               size     = 16,
               fontface = "bold")

p = ggplot(data = data,
           mapping = aes(time, value)) +
    geom_line() +
    theme_classic(base_size = 12) +
    ylab("squared relative error") +
    xlab("timestamp")

plot_grid(p_title, p, ncol = 1, rel_heights = c(0.15, 1))
ggsave("graphs/c027_squarederrors.pdf",
       height = (8.267/2), width = 11.692)


## end of file ##
