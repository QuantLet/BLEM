

# Specify flags for tuning hyperparameters: set default values
 FLAGS = flags(
    flag_integer("batch_size"              , 32),
    flag_integer("layer1_units"            , 128),
    flag_integer("layer1_dropout"          , 0.2),
    flag_integer("layer1_recurrent_dropout", 0.2),
    flag_integer("layer2_units"            , 64),
    flag_integer("layer2_dropout"          , 0.2),
    flag_integer("layer2_recurrent_dropout", 0.2),
    flag_integer("layer3_units"            , 32),
    flag_integer("layer3_dropout"          , 0.2),
    flag_integer("layer3_recurrent_dropout", 0.2)
)

# Set up training data generator function
train_gen   = dataGenerator(input_data,
                            target_data = targets,
                            lookback    = lookback,
                            steps       = steps,
                            min_index   = min_index_train,
                            max_index   = max_index_train,
                            batch_size  = FLAGS$batch_size)

train_steps =
    floor((max_index_train - min_index_train - lookback) /
              (steps * FLAGS$batch_size))

# Set up validation data generator function
val_gen     = dataGenerator(input_data,
                            target_data = targets,
                            lookback    = lookback,
                            steps       = steps,
                            min_index   = min_index_val,
                            max_index   = max_index_val,
                            batch_size  = FLAGS$batch_size)

val_steps   = 
    floor((max_index_val - min_index_val - lookback) /
              (steps * FLAGS$batch_size))

# Set up model
model  = keras_model_sequential() %>%
    layer_lstm(units              = FLAGS$layer1_units,
               input_shape        = list(NULL, dim(input_data)[[-1]]),
               batch_size         = FLAGS$batch_size,
               dropout            = FLAGS$layer1_dropout,
               recurrent_dropout  = FLAGS$layer1_recurrent_dropout,
               stateful           = FALSE,
               return_sequences   = TRUE) %>%
    layer_lstm(units              = FLAGS$layer2_units,
               dropout            = FLAGS$layer2_dropout,
               recurrent_dropout  = FLAGS$layer2_recurrent_dropout,
               stateful           = FALSE,
               return_sequences   = TRUE) %>%
    layer_lstm(units              = FLAGS$layer3_units,
               dropout            = FLAGS$layer3_dropout,
               recurrent_dropout  = FLAGS$layer3_recurrent_dropout,
               stateful           = FALSE,
               return_sequences   = FALSE) %>%
    layer_dense(units             = 1)

# Compile model
model %>% compile(
    optimizer = optimizer_adam(),
    loss      = "mae"
)

# Define training callbacks
callbacks = list(
    #callback_tensorboard("logs/"%&%run),
    
    callback_early_stopping(
        monitor   = "val_loss",
        min_delta = 0.001,
        patience  = 3,
        mode      = "auto"),
    
    callback_model_checkpoint(
        filepath          = "models/checkpoint_3layers.hdf5",
        save_weights_only = FALSE,
        save_best_only    = TRUE,
        verbose           = 1)
)

# Fit model
system.time(
    history <- model %>% # does not work with '=' as assignment operator
        fit_generator(
            train_gen,
            steps_per_epoch  = train_steps,
            epochs           = 50,
            validation_data  = val_gen,
            validation_steps = val_steps,
            callbacks        = callbacks
        ))

# Save model
save_model_hdf5(model, "models/model_3layers.hdf5")


## end of file ##
