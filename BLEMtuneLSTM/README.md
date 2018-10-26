[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **BLEMtuneLSTM** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml


Name of Quantlet: BLEMtuneLSTM

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Tunes hyperparameters of LSTM recurring neural network on one randomly chosen energy consumer data set.

Keywords: household energy prediction, energy consumption, energy production, LSTM, machine learning, hyperparameter tuning, Keras, TensorFlow

Author: Michael Kostmann

See also:
- BLEMdataGlimpse
- BLEMdescStatEnergyData
- BLEMevaluateEnergyPreds
- BLEMevaluateMarketSim
- BLEMmarketSimulation
- BLEMplotEnergyData
- BLEMplotEnergyPreds
- BLEMplotPredErrors
- BLEMpredictLASSO
- BLEMpredictNaive
- BLEMtuneLSTM
- BLEMplotScalingForLSTM

Submitted:  26.10.2018

Input: 100 consumer and prosumer datasets containing energy readings for one year (2017) in 3-minute intervals (csv-files)

Output:
- trained LSTM neural network models (hdf5-files)
- logs of training epochs (log-files)

```

### R Code
```r



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
path  = "../data/consumer/"
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

```

automatically created on 2018-10-26