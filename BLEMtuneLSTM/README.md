<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
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

Submitted: 26.10.2018

Input: 100 consumer and prosumer datasets containing energy readings for one year (2017) in 3-minute intervals (csv-files)

Output: 
- trained LSTM neural network models (hdf5-files)
- logs of training epochs (log-files)

```
