<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: BLEMplotPredErrors

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Generates plots of total over-/underestimation errors of naive, LASSO, and LSTM models for multiple energy consumer and prosumer data sets.

Keywords: household energy prediction, machine learning, prediction errors, barplot, LSTM neural network, LASSO regression, naive predictor, persistence model, energy consumer, energy prosumer

Author: Michael Kostmann

See also: 
- BLEMdataGlimpse
- BLEMdescStatEnergyData
- BLEMevaluateEnergyPreds
- BLEMevaluateMarketSim
- BLEMmarketSimulation
- BLEMplotEnergyData
- BLEMplotEnergyPreds
- BLEMpredictLASSO
- BLEMpredictLSTM
- BLEMpredictNaive
- BLEMtuneLSTM
- BLEMplotScalingForLSTM

Submitted: 26.10.2018

Input: 
- data: 100 consumer and 100 prosumer data sets containing electricity readings in 3-minute intervals (csv-files)
- predictions: 15-minute interval prediction of electricity consumption for every consumer and of electricity production for prosumer forecasted with LASSO, LSTM, and persistence model (csv-files)

Output: barplots for each forecasting model (LASSO, LSTM, persistence) depicting total over- and underestimation errors for 88 consumer data sets and 12 prosumer data sets

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMplotPredErrors/c_barplot_LASSO_overunderestimation.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMplotPredErrors/c_barplot_LSTM_overunderestimation.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMplotPredErrors/c_barplot_naive_overunderestimation.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMplotPredErrors/p_barplot_LASSO_overunderestimation.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMplotPredErrors/p_barplot_LSTM_overunderestimation.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMplotPredErrors/p_barplot_naive_overunderestimation.jpg" alt="Image" />
</div>

