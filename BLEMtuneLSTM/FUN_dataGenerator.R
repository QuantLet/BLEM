

## Function: generator
## Author: Michael Kostmann

## The generator function is called repeatedly during the model training,
## testing and prediction of LSTM RNN in Keras to obtain sequences of
## values from the data

## Args:     input_data   - array of floating-point data, from which the gen-
##                          erator function should sample
##           target_data  - vector of true/target values (here: aggregated to
##                          input_data in 15-min resolution); optional, can be
##                          omitted if "predict" is set to TRUE
##           lookback     - number of previous time steps that should be used
##                          as input for the model
##           min_index    - index of the first time step that should be used
##           max_index    - index of the last time step that should be used
##           steps        - number of time steps that should be skipped for next
##                          forecast (i.e., in the case of 15-min aggregated
##                          1-step ahead forecast and 3-min input data resolution
##                          5 time steps in the input data should be skipped)
##           batch_size   - number of samples fed into the model at once
##           predict      - set to TRUE, to generate samples only, without
##                          target vector for prediction with trained model
##           
## Returns:  samples      - array containing sample data with dimensions
##                          batch_size x lookback x features in original data
##           targets      - target values that should be used to train the
##                          model, has dimensions batch_size x forecast



dataGenerator = function(input_data,
                         target_data,
                         lookback,
                         min_index,
                         max_index,
                         steps = 5,
                         batch_size = 64,
                         predict = FALSE) {
    
    # Set max_index to length of input_data if max_index is not specified
    if (is.null(max_index)){
        max_index = nrow(input_data) 
    }
    
    # Initialize counter
    i = min_index + lookback
    
    # Define function returning samples of input_data
    function() {
        
        # Set counter to min_index if it is below max_index to provide
        # samples infinitively 
        if (i + batch_size >= max_index) {
            i <<- min_index + lookback
        }
        
        # Select row indices of batches
        rows = seq(i, min(i + batch_size*steps - 1, max_index), by = steps)
        
        # Increase counter with superassignment
        i <<- i + length(rows) * steps
        
        # Initialize sample and target arrays
        samples = array(0, dim = c(length(rows),
                                    lookback,
                                    dim(input_data)[[-1]]))
        
        targets = array(0, dim = c(length(rows)))
        
        # Write data according to indices set in rows into arrays
        for (j in 1:(length(rows))) {
            indices = seq(rows[[j]] - lookback,rows[[j]])[1:dim(samples)[[2]]]
            
            samples[j,,] = input_data[indices, ]
            
            if(predict != TRUE) {
                targets[j] = target_data[floor(rows[[j]]/steps)+1]
            }
        }
        
        # Return samples and targets arrays
        if(predict == TRUE) {
            return(samples)
        } else {
            list(samples, targets)   
        }
    }
}
