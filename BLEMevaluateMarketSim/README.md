<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: BLEMevaluateMarketSim

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Generates plots and tables to evaluate the outcomes of three market simulations of a blind double auction as implemented in a smart contract by Mengelkamp et al. (2018) with and without predictions of energy consumption values.

Keywords: blind double auction, market mechanism, balanced supply, oversupply, undersupply, predicted energy consumption values, true energy consumption values, barplot, equilibrium price, local energy market, loss, prediction error, percentage savings, percentage loss

Author: Michael Kostmann

See also: 
- BLEMdataGlimpse
- BLEMdescStatEnergyData
- BLEMevaluateEnergyPreds
- BLEMmarketSimulation
- BLEMplotEnergyData
- BLEMplotEnergyPreds
- BLEMplotPredErrors
- BLEMpredictLASSO
- BLEMpredictLSTM
- BLEMpredictNaive
- BLEMtuneLSTM
- BLEMplotScalingForLSTM

Submitted: 26.10.2018

Input: 
- data: 100 consumer and 100 prosumer data sets containing electricity readings in 3-minute intervals (csv-files)
- predictions: 15-minute interval prediction of electricity consumption for every consumer forecasted with LASSO model (csv-file)
- market outcomes: market simulations with true and predicted electricity consumption values in three different supply scenarios (balanced, over-, and undersupply) (RData-files)

Output: 
- barplots showing savings due to participation in local energy market and loss due to prediction errors in local energy market in three different supply scenarios
- tables (as csv-files for latex) summarising savings due to participation in local energy market and loss due to prediction errors in local energy market in three different supply scenarios

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateMarketSim/totalenergycost_balanced.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateMarketSim/totalenergycost_oversupply.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateMarketSim/totalenergycost_undersupply.jpg" alt="Image" />
</div>

