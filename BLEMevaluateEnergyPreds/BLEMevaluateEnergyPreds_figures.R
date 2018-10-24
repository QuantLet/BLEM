

## Plot heatmaps of error measures

# Load packages
packages  = c("reshape",
              "cowplot")
invisible(lapply(packages, library, character.only = TRUE))

# Load user-defined functions
functions = c("FUN_loadErrorMeasures.R")
invisible(lapply(functions, source))

# Function for easy string pasting
"%&%"     = function(x, y) {paste(x, y, sep = "")}



## CONSUMER ##


# Define vector with names of error measures
measures_c  = c("MAE", "MAPE", "MASE", "RMSE", "NRMSE")

# Define vector of datasets to exclude from error analysis
remove   = c(13, 21, 34, 45, 52, 56, 66, 75, 77, 79, 81)

# Load error measures
error_measures_c = loadErrorMeasures("predictions/consumer/",
                                      return = measures_c,
                                      remove = remove)

# Create index vector for x-Axis labels
id_c = read.csv("consumer_labels.csv",
                stringsAsFactors = FALSE)[-c(26, remove), 2]

# Combine into dataframe
for(i in measures_c) {
    
    # Bind absolute error measures to one dataframe
    assign(i, data.frame("ID"    = id_c,
                         "naive" = error_measures_c[["naive_"%&%i]],
                         "LASSO" = error_measures_c[["LASSO_"%&%i]],
                         "LSTM"  = error_measures_c[["LSTM_"%&%i]]))
    
    # Reshape into long-format
    long = melt(get(i), id.vars = "ID")
    
    # Plot heatmap
    p_title = ggdraw() + 
        draw_label(i%&%" of energy consumption prediction",
                   size     = 16,
                   fontface = "bold")
    
    p = long %>% 
        ggplot(aes(ID, variable)) + 
        geom_tile(aes(fill = value),
                  color = "white") +
        scale_x_discrete(expand = c(0, 0)) +
        scale_y_discrete(expand = c(0, 0)) +
        scale_fill_viridis_c(begin = 1,
                             end = 0,
                             option = "viridis",
                             name = i) +
        theme_minimal(base_size = 12) +
        theme(axis.title.y = element_blank(),
              axis.text.x  = element_text(angle = 90,
                                          vjust = 0.5,
                                          size  = 8)) +
        xlab("consumer ID")
    
    plot_grid(p_title, p, ncol = 1, rel_heights = c(0.15, 1))
    ggsave("graphs/c_heatmap_"%&%i%&%".pdf",
           height = (8.267/4), width = 11.692)
    
    # Plot boxplot
    p_title_b <- ggdraw() + 
        draw_label("Boxplots of "%&%i%&%" for consumption predictions",
                   size     = 16,
                   fontface = "bold")
    
    p_b <- long %>%
        ggplot(aes(variable, value)) +
        geom_boxplot(aes(variable, value)) +
        scale_y_continuous(limits = quantile(long$value,
                                             c(0.0, 0.95),
                                             na.rm = TRUE)) +
        theme_classic(base_size = 12) +
        theme(axis.title.x = element_blank()) +
        ylab(i)
    
    plot_grid(p_title_b, p_b, ncol = 1, rel_heights = c(0.15, 1))
    ggsave("graphs/c_boxplot_"%&%i%&%".pdf",
           height = 8.267, width = 11.692/2)
    
}


### Median relative error measures (MdAPE and NRMdSE)


# Define vector with names of error measures
measures_median         = c("MdAPE", "NRMdSE")

# Load error measures
error_measures_c_median = loadErrorMeasures("predictions/consumer_median/",
                                            return = measures_median,
                                            remove = remove)

# Combine into dataframe
for(i in measures_median) {
    
    # Bind absolute error measures to one dataframe
    assign(i, data.frame("ID"    = id_c,
                         "naive" = error_measures_c_median[["naive_"%&%i]],
                         "LASSO" = error_measures_c_median[["LASSO_"%&%i]],
                         "LSTM"  = error_measures_c_median[["LSTM_"%&%i]]))
    
    # Reshape into long-format
    long = melt(get(i), id.vars = "ID")
    
    # Plot heatmap
    p_title1 = ggdraw() + 
        draw_label(i%&%" of energy consumption prediction",
                   size     = 16,
                   fontface = "bold")
    
    p1 = long %>% 
         ggplot(aes(ID, variable)) + 
         geom_tile(aes(fill = value),
                   color = "white") +
         scale_x_discrete(expand = c(0, 0)) +
         scale_y_discrete(expand = c(0, 0)) +
         scale_fill_viridis_c(begin = 1,
                              end = 0,
                              option = "viridis",
                              name = i) +
         theme_minimal(base_size = 12) +
         theme(axis.title.y = element_blank(),
               axis.text.x  = element_text(angle = 90,
                                           vjust = 0.5,
                                           size  = 8)) +
         xlab("consumer ID")
    
    plot_grid(p_title1, p1, ncol = 1, rel_heights = c(0.15, 1))
    ggsave("graphs/c_heatmap_"%&%i%&%".pdf",
           height = (8.267/4), width = 11.692)
    
}


## PROSUMER ##


# Define vector with names of error measures
measures_p  = c("MAE", "MASE", "RMSE")

# Load error measures
error_measures_p = loadErrorMeasures("predictions/prosumer/",
                                      return = measures_p,
                                      remove = NULL)

# Create index vector for x-Axis labels
id_p = read.csv("prosumer_labels.csv",
                stringsAsFactors = FALSE)[c(19, 24, 26, 30, 31, 72,
                                            75,83, 84, 85, 86, 89), 2]

# Combine into dataframe
for(i in measures_p) {
    
    # Bind absolute error measures to one dataframe
    assign(i, data.frame("ID"    = id_p,
                         "naive" = error_measures_p[["naive_"%&%i]],
                         "LASSO" = error_measures_p[["LASSO_"%&%i]],
                         "LSTM"  = error_measures_p[["LSTM_"%&%i]]))
    
    # Reshape into long-format
    long = melt(get(i), id.vars = "ID")
    
    # Plot heatmap
    p_title2 = ggdraw() + 
        draw_label(i%&%" of energy production prediction",
                   size     = 16,
                   fontface = "bold")
    
    p2 = long %>%
        ggplot(aes(ID, variable)) + 
        geom_tile(aes(fill = value),
                  color = "white") +
        scale_x_discrete(expand = c(0, 0)) +
        scale_y_discrete(expand = c(0, 0)) +
        scale_fill_viridis_c(begin = 1,
                             end = 0,
                             option = "viridis",
                             name = i) +
        theme_minimal(base_size = 12) +
        theme(axis.title.y = element_blank(),
              axis.text.x  = element_text(angle = 90,
                                          vjust = 0.5,
                                          size  = 8)) +
        xlab("prosumer ID")
    
    plot_grid(p_title2, p2, ncol = 1, rel_heights = c(0.15, 1))
    ggsave("graphs/p_heatmap_"%&%i%&%".pdf",
           height = (8.267/4), width = 11.692)
    
    # Plot boxplot
    p_title2_b <- ggdraw() + 
        draw_label("Boxplots of "%&%i%&%" for production predictions",
                   size     = 16,
                   fontface = "bold")
    
    p2_b <- long %>%
        ggplot(aes(variable, value)) +
        geom_boxplot(aes(variable, value)) +
        theme_classic(base_size = 12) +
        theme(axis.title.x = element_blank()) +
        ylab(i)
    
    plot_grid(p_title2_b, p2_b, ncol = 1, rel_heights = c(0.15, 1))
    ggsave("graphs/p_boxplot_"%&%i%&%".pdf",
           height = 8.267, width = 11.692/2)
    
}


## end of file ##
