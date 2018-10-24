

## Plot energy production of all relevant prosumers in testing period
## Author: Michael Kostmann


# Load packages
packages = c("cowplot")
invisible(lapply(packages, library, character.only = TRUE))

# Source user-defined functions
functions = c("FUN_getTargets.R")
invisible(lapply(functions, source))

# Function for easy string pasting
"%&%"     = function(x, y) {paste(x, y, sep = "")}

# Specify paths to directories containing consumer and prosumer datasets
path_c    = "data/consumer/"
path_p    = "data/prosumer/"

files_p    = substring(list.files(path_p, pattern = "*.csv"),
                     1, 17)[c(19, 24, 26, 30, 31, 72, 75, 83, 84, 85, 86, 89)]

# Load net production data per 15-minute time interval
prod = matrix(NA, nrow = 8836, ncol = length(files_p))
i = 0

for(id in files_p) {
    i = i+1
    prod[, i] = getTargets(path_p,
                            id,
                            return = "production",
                            min = "2017-10-01 00:03",
                            max = "2018-01-01 00:00")
}

# Vector of x-axis labels
ids = substring(files_p, 15, 17)

# Initiate list to save plots for plotting grid
plotgrids = list()

# Loop over specified producers
for(i in 1:length(files_p)){
    
    p_title =  ggdraw() + 
               draw_label("Prosumer "%&%ids[i],
                          size     = 10,
                          fontface = "bold")
    
    t = data.frame("time"   = seq.POSIXt(as.POSIXct("2017-10-01 00:00"),
                                         as.POSIXct("2018-01-01 00:00"),
                                         by = 900)[1:nrow(prod)],
                    "value" = prod[, i])
    
    p = ggplot(t, aes(x = time, y = value)) +
        geom_line() +
        scale_y_continuous(limits = c(0, max(prod))) +
        ylab("kWh/15 minutes") +
        xlab("timestamp") +
        theme_classic(base_size = 8)
    
    plotgrids[[i]] = plot_grid(p_title, p, ncol = 1, rel_heights = c(0.1, 1))

}

plot_grid(plotlist = plotgrids, nrow = 4, ncol = 3)
ggsave("graphs/producers_all.pdf", height = 8.267, width = 11.692)


## end of file ##
