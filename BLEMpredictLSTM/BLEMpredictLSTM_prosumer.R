

## Make predictions with LSTM model, and calculate error measures
## for prosumer datasets
## Author: Michael Kostman


# Clear global environment
rm(list=ls())

# Load packages
packages  = c("keras")
invisible(lapply(packages, library, character.only = TRUE))

# Source user-defined functions
functions = c("FUN_getData.R",
              "FUN_tagDaysOff.R",
              "FUN_scaleData.R",
              "FUN_getTargets.R",
              "FUN_dataGenerator.R",
              "FUN_calcErrorMeasure.R")
invisible(lapply(functions, source))

# Function for easy string pasting
"%&%"     = function(x, y) {paste(x, y, sep = "")}

# Specify path to directory containing prosumer datasets
path      = "data/prosumer"  #use this path if using windows
#path      = "data/prosumer/"  #use this path if using mac

# Set index to number between 1 and 100 to select individual dataset;
# if all consumer datasets should be used, set index to -26

#for windows
files = paste0("/", substring(list.files(path, pattern = "*.csv"),
                               1,
                               17))[c(19, 24, 26, 30, 31, 72,
                                      75, 83, 84, 85, 86, 89)]

#for mac
#files = substring(list.files(path, pattern = ".csv"),
#                   1,
#                   17)[c(19, 24, 26, 30, 31, 72,
#                         75, 83, 84, 85, 86, 89)]

for(id in files) {
    id = substring(id, 1, 18) #for windows
    #id = substring(id, 1, 17) #for mac
    
    # Get data
    unscaled = getData(path   = path,
                       data   = "single",
                       id     = id,
                       return = "production")
    
    # Scale data
    scaled = scaleData(data     = unscaled,
                       option   = "log-normalize",
                       split    = "2017-10-01 00:00",
                       time.tbl = FALSE)$data
    
    # Tag weekends and holidays
    input_data = tagDaysOff(scaled)
    
    
    ###  Model training  ###
    
    # Get target values for supervised learning
    targets = getTargets(path   = path,
                         id     = id,
                         return = "production",
                         min    = "2017-01-01 00:00",
                         max    = "2018-01-01 00:00")
    
    # Set parameters
    lookback        = 7*24*60/3              # 7 days back as input
    batch_size      = 32                     # 32 samples are input at once
    steps           = 5                      # every 15 mins one prediction
    min_index_train = 1
    max_index_train = 1+ lookback + 
                           batch_size * steps * 700
    min_index_val   = max_index_train + 1    
    max_index_val   = max_index_train + 1 + lookback +
                           batch_size * steps * 96
    
    # Set up training data generator function
    train_gen = dataGenerator(input_data,
                               target_data = targets,
                               lookback    = lookback,
                               steps       = steps,
                               min_index   = min_index_train,
                               max_index   = max_index_train,
                               batch_size  = batch_size)
    
    train_steps =
        (max_index_train - min_index_train - lookback) / (steps * batch_size)
    
    # Set up validation data generator function
    val_gen   = dataGenerator(input_data,
                               target_data = targets,
                               lookback    = lookback,
                               steps       = steps,
                               min_index   = min_index_val,
                               max_index   = max_index_val,
                               batch_size  = batch_size)
    
    val_steps = 
        (max_index_val - min_index_val - lookback) / (steps * batch_size)

    # Specify model layers, hidden units, and dropout
    #  accroding to model tuning results
    model_best  = keras_model_sequential() %>%
        layer_lstm(units             = 32,
                   input_shape       = list(NULL, dim(input_data)[[-1]]),
                   batch_size        = batch_size,
                   stateful          = FALSE,
                   return_sequences  = FALSE)  %>%
        layer_dense(units            = 1)
    
    # model_best  = keras_model_sequential() %>%
    #     layer_lstm(units            = 64,
    #                input_shape      = list(NULL, dim(input_data)[[-1]]),
    #                batch_size       = batch_size,
    #                stateful         = FALSE,
    #                return_sequences = TRUE)  %>%
    #     layer_lstm(units            = 64,
    #                stateful         = FALSE,
    #                return_sequences = FALSE) %>%
    #     layer_activation("linear")           %>%
    #     layer_dense(units           = 1)
    
    # Compile model: set optimizer and loss function
    model_best  %>% compile(
        optimizer = optimizer_adam(),
        loss      = "mae"
    )
    
    # Specify callbacks
    callbacks = list(
        callback_tensorboard("logs/"%&%run),
        
        callback_early_stopping(
            monitor   = "val_loss",
            min_delta = 0.001,
            patience  = 3,
            mode      = "auto"),
        
        callback_model_checkpoint(
            filepath          = "models/production/checkpoint.hdf5",
            save_weights_only = FALSE,
            save_best_only    = TRUE,
            verbose           = 1)
    )
    
    
    # Train model            
    tensorboard("logs/"%&%run)
    
    system.time(
        history_simple <- model_best %>% # does not work with '='
                                         # as assignment operator
            fit_generator(
                train_gen,
                steps_per_epoch  = train_steps,
                epochs           = 50,
                validation_data  = val_gen,
                validation_steps = val_steps,
                callbacks        = callbacks
            ))
    
    # for windows
    model_best %>%
        save_model_hdf5("models/production"%&%id%&%".hdf5")
    
    # for mac
    # model_best %>%
    #     save_model_hdf5("models/production/"%&%id%&%".hdf5")
    
    
    
    ###  Model evaluation  ###
    
    # for windows
    pred_model = load_model_hdf5("models/production"%&%id%&%".hdf5")
    
    # for mac
    #pred_model = load_model_hdf5("models/production/"%&%id%&%".hdf5")
    
    # Set parameters
    min_index_test = which(unscaled$time == "2017-09-24 00:00")
    max_index_test = nrow(input_data)
    
    # Set up prediction data generator function
    predict_gen = dataGenerator(input_data,
                                lookback    = lookback,
                                steps       = steps,
                                min_index   = min_index_test,
                                max_index   = max_index_test,
                                batch_size  = batch_size,
                                predict     = TRUE)
    
    test_steps =
        floor((max_index_test - min_index_test - lookback)/(5*batch_size))
    
    # Make predictions
    lstm_predictions = numeric()
    pb               = txtProgressBar(min = 0, max = test_steps, style = 3)
    idx              = seq(1,
                           (max_index_test - min_index_test) / 5,
                           by = batch_size)
    
    for(i in 1:test_steps){
        
        lstm_predictions[idx[i]:(idx[i+1]-1)] = pred_model %>%
            predict(predict_gen())
        
        setTxtProgressBar(pb, i)
    }
    
    # Get true values
    targets = getTargets(path   = path,
                         id     = id,
                         return = "production",
                         min    = "2017-10-01 00:00",
                         max    = "2018-01-01 00:00")[1:(test_steps*batch_size)]
    
    # Calculate error measures
    if(!exists("error_measures")) {error_measures = list()}
    error_measures[[id]] = calcErrorMeasure(predictions = lstm_predictions,
                                            targets     = targets,
                                            return      = "all")
    
    # Save predictions to dataframe
    if(!exists("lstm_all_predictions")) {
        lstm_all_predictions = matrix(NA,
                                      nrow = length(lstm_predictions),
                                      ncol = length(files))
        col = 0
    }
    col = col+1
    lstm_all_predictions[, col] = lstm_predictions
    
    # Print progress
    print(id%&%" completed")
}

# Save error measures to file
save(error_measures, file = "output/prosumer/LSTM_error_measures.RData")

# Save predictions for all datasets to csv-file
write.csv(lstm_all_predictions, "output/prosumer/LSTM_predictions.csv")


## end of file ##
