<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: BLEMpredictLASSO

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Fits LASSO regression models for 99 consumer and 12 prosumer data sets with k-fold cross-validation, uses fitted models to make predictions in testing period and calculates various error measures for model performance.

Keywords: household energy prediction, energy consumption, energy production, LASSO, machine learning, cross-validation, regression model, error measures, model performance, MAE, MAPE, MASE, RMSE, NRMSE

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
- BLEMpredictLSTM
- BLEMpredictNaive
- BLEMtuneLSTM
- BLEMplotScalingForLSTM

Submitted: 26.10.2018

Input: 100 consumer and prosumer datasets containing energy readings for one year (2017) in 3-minute intervals (csv-files)

Output: 
- predictions of energy consumption/production in 15-minute intervals (csv-files)
- error measures calculated on testing data (Rdata-files)

```
