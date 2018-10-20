

## Tune LSTM network architecture
## Author: Michael Kostmann


# Load packages
packages  = c("keras", 
              "tfruns")
invisible(lapply(packages, library, character.only = TRUE))

# Source user-defined functions
functions = c("FUN_getData.R",
              "FUN_tagDaysOff.R",
              "FUN_scaleData.R",
              "FUN_getTargets.R",
              "FUN_dataGenerator.R")
invisible(lapply(functions, source))

# Specify random dataset to tune models on

# For windows
# path = "data/consumer"
# files = list.files(path, pattern = ".csv")
# id    = paste0("/", substring(sample(files, 1), 1, 17))

# For Mac
path  = "data/consumer/"
files = list.files(path, pattern = ".csv")
id    = substring(sample(files, 1), 1, 17)

# Get data
unscaled = getData(path    = path,
                    data   = "single",
                    id     = id,
                    return = "consumption")

# Scale data
scaled = scaleData(unscaled,
                   option   = "log-normalize",
                   time.tbl = FALSE)$data

# Tag weekends and holidays
input_data = tagDaysOff(scaled)

# Get target values for supervised learning
targets =  getTargets(path = path,
                      id   = id,
                      min  = "2017-01-01 00:00",
                      max  = "2018-01-01 00:00")

# Set parameters
lookback        = 7*24*60/3              # 7 days back as input
steps           = 5                      # every 15 mins a prediction is made
min_index_train = 1
max_index_train = 105600
min_index_val   = max_index_train + 1    
max_index_val   = max_index_train + 20480



###  Start training runs  ###

# Tuning with one layer
tuning_run("tuning_runs_1layer.R",
           runs_dir = "tuning_runs/1layer",
           sample   = 0.2,
           confirm  = FALSE,
           flags    = list(
               layer1_units             = c(128, 64, 32),
               layer1_dropout           = c(0, 0.2, 0.4),
               layer1_recurrent_dropout = c(0, 0.2, 0.4)
           ))

# Tuning with two layers
tuning_run("tuning_runs_2layers.R",
           runs_dir = "tuning_runs/2layers",
           sample   = 0.5,
           confirm  = FALSE,
           flags    = list(
               layer2_units             = c(128, 64, 32),
               layer2_dropout           = c(0, 0.2, 0.4),
               layer2_recurrent_dropout = c(0, 0.2, 0.4)
           ))

# Tuning with three layers
tuning_run("tuning_runs_3layers.R",
           runs_dir = "tuning_runs/3layers",
           sample   = 0.5,
           confirm  = FALSE,
           flags    = list(
               layer3_units             = c(128, 64, 32),
               layer3_dropout           = c(0, 0.2, 0.4),
               layer3_recurrent_dropout = c(0, 0.2, 0.4)
           ))


## end of file ##
