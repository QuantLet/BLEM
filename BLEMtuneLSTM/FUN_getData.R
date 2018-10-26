

## Function: getData
## Author: Michael Kostmann

## Args:     path   - path of the directory that contains the datasets of
##                    consumers or prosumers that should be read in
##           data   - Set to "all" to load all datasets in directory or to
##                    "single" to load only single dataset specified in "id".
##                    If "single" is set, argument "id" must be given.
##           id     - specifies consumer or prosumer dataset that should be
##                    read in if "single" is specified in "data". Must be of
##                    the form "consumer-00000001" or "producer-00000001".
##           return - which values to return in the data frame. Arguments are
##                    "consumption" (first-order difference of energy),
##                    "energy", "energyOut", and "production" (first-order
##                    difference of energyOut)
##           
## Returns:  df     - time tibble with the values specified in the return arg
##                    of one or all consumer(s)/prosumer(s) in one column



getData = function(path, data = "all", id = NULL, return = "consumption") {
    
    # Load packages
    packages = c("data.table", "tidyverse", "tidyquant", "tibbletime")
    invisible(lapply(packages, library, character.only = TRUE))
    
    # Function for easy string pasting
    "%&%" = function(x, y) {paste(x, y, sep = "")}
    
    # Supress start of browser by error handler
    stop_nobrowser = function(x) {
        opt = options()
        options(error = NULL)
        on.exit(options(opt))
        stop(x, call. = FALSE)
    }
    
    # file.exists-function that is robust to macOS/windows OS differences
    robust.file.exists <- function(x) { 
        if (.Platform$OS == "windows" && grepl("[/\\]$", x)) { 
            file.exists(dirname(x)) 
        } else file.exists(x) 
    } 
    
    # Check wether "path" and "id" are correctly specified
    if(!robust.file.exists(path)) {
        stop_nobrowser("Path not specified correctly: "
                       %&%path%&%" does not exist.")}
    
    if(data == "single"){
        if(!robust.file.exists(path%&%id%&%".csv")) {
            stop_nobrowser("id not specified correctly: "
                           %&%"File "%&%path%&%id%&%".csv does not exist")
        }
    }
    
    
    
    # List all consumer/prosumer datasets in directory specified by "path" and
    # write into "files" or write dataset specified by "id" in to "files"
    files   = switch(data,
                      "all"    = list.files(path = path, pattern = "*.csv"),
                      "single" = id%&%".csv"
                      )
    
    # Generate variable to name columns in data frame that is output
    id      = if(grepl("consumer", path)) {
                   gsub(".*?([0]{5})([0-9]{3}).*", "c\\2", files)
               } else {
                   if(grepl("prosumer", path)) {
                       gsub(".*?([0]{5})([0-9]{3}).*", "p\\2", files)
                   } else {
                       stop_nobrowser("Path must contain 'consumer' or 'prosumer'")
                   }
               }
    
    # Check wether path is correct
    if(!robust.file.exists(path%&%files[1])) {stop_nobrowser("Path should end with '/'")}
    
    # Read in first dataset listed in "files"
    df      = fread(path%&%files[1],
                     header    = T,
                     sep       = ',',
                     integer64 = "numeric")
    
    # Change unix millisecond timestamp into date format
    df$time = as_datetime(df$time/1000, tz = "CET")
    
    # Format data and keep only relevant variables specified by "return"
    df      = switch(return,
                     "consumption" = df %>%
                         mutate(!!(id[1]%&%"_cons") :=
                                    c(NA, diff(energy,
                                               lag = 1)*10^-10)) %>%
                         select(time, !!(id[1]%&%"_cons")) %>%
                         slice(-1),
                     
                     "energy"      = df %>%
                         mutate(!!(id[1]%&%"_energy") :=
                                    energy*10^-10) %>%
                         select(time, !!(id[1]%&%"_energy")),
                     
                     "energyOut"   = df %>%
                         mutate(!!(id[1]%&%"_energyOut") :=
                                    energyOut*10^-10) %>%
                         select(time, !!(id[1]%&%"_energyOut")),
                     
                     "production"  = df %>%
                         mutate(!!(id[1]%&%"_prod") :=
                                    c(NA, diff(energyOut,
                                               lag = 1)*10^-10)) %>%
                         select(time, !!(id[1]%&%"_prod")) %>%
                         slice(-1)
    ) %>%
        as_tbl_time(time)
    
    
    # Read in all further datasets specified in files following the same
    # logic as above if "data" was set to "all"
    
    if(length(files) > 1) {
        
        # Initialize progress bar
        pb = txtProgressBar(min = 0, max = length(files), style = 3)
        
        for(i in 2:length(files)){
            
            # Read in and format data
            x = fread(path%&%files[i],
                       header    = T,
                       sep       = ',',
                       integer64 = "numeric")
            
            x$time = as_datetime(x$time/1000, tz = "CET")
            
            x = switch(return,
                        "consumption" = x %>%
                            mutate(!!(id[i]%&%"_cons") :=
                                       c(NA, diff(energy,
                                                  lag = 1)*10^-10)) %>%
                            select(!!(id[i]%&%"_cons")) %>%
                            slice(-1),
                        
                        "energy"      = x %>%
                            mutate(!!(id[i]%&%"_energy") :=
                                       energy*10^-10) %>%
                            select(!!(id[i]%&%"_energy")),
                        
                        "energyOut"   = x %>%
                            mutate(!!(id[i]%&%"_energyOut") :=
                                       energyOut*10^-10) %>%
                            select(!!(id[i]%&%"_energyOut")),
                        
                        "production"  = x %>%
                            mutate(!!(id[i]%&%"_prod") :=
                                       c(NA, diff(energyOut,
                                                  lag = 1)*10^-10)) %>%
                            select(!!(id[i]%&%"_prod")) %>%
                            slice(-1)
            )
            
            # Bind existing "df" with next read in dataset "x" if there is no
            # missing data in "x"
            
            switch(return,
                   "consumption" = nrow <- 175200,
                   "energy"      = nrow <- 175201,
                   "energyOut"   = nrow <- 175201,
                   "production"  = nrow <- 175200)
            
            if(nrow(x) == nrow) {
                df = list(df, x) %>%
                      bind_cols() %>%
                      as_tbl_time(index = time)
            
                setTxtProgressBar(pb, i)
                
            } else {
                warning(paste(files[i]%&%" has missing data and was not added",
                        "to returned tibble time frame", sep = " "), call. = FALSE)
            }
            }
        close(pb)   
    }
    
    return(df)
}

