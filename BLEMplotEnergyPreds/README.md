<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: BLEMplotEnergyPreds

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Exemplary plots true and forecasted values predicted with LSTM, LASSO, and persistence models for 24 hours.

Keywords: household energy prediction, energy consumption, energy production, forecast, LSTM, LASSO, persistence model, benchmark, plot, glimpse, regression model, machine learning

Author: Michael Kostmann

See also: 
- BLEMdataGlimpse
- BLEMdescStatEnergyData
- BLEMevaluateEnergyPreds
- BLEMevaluateMarketSim
- BLEMmarketSimulation
- BLEMplotEnergyData
- BLEMplotPredErrors
- BLEMpredictLASSO
- BLEMpredictLSTM
- BLEMpredictNaive
- BLEMtuneLSTM
- BLEMplotScalingForLSTM

Submitted: 26.10.2018

Datafile: for your data sets - delete if not used

Input: 
- data: exemplary one consumer and one prosumer data set containing energy consumption and production readings in 3-minute intervals (csv-files)
- predictions: 15-minute interval prediction of electricity consumption and energy production forecasted with LASSO, LSTM, and persistence model (csv-files)

Output: line graphs showing true and predicted consumption/production values

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMplotEnergyPreds/c011_pred_cons.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMplotEnergyPreds/p024_pred_prod.jpg" alt="Image" />
</div>

