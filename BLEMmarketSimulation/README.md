<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: BLEMmarketSimulation

Published in: 'Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets'

Description: Simulates the market mechanism (blind double auction), which was implemented by Mengelkamp et al. (2018) in smart contract on a private Ethereum Blockchain, with real consumption and production data in three different supply scenarios (balanced, over-, and undersupply) and with true and predicted energy consumption values.

Keywords: blind double auction, market simulation, energy trading, zero-intelligence traders, smart grid, blockchain, smart contract, market mechanism, market outcome, equilibrium price, line graphs, time series, energy prediction, forecast, prediction error, energy cost, energy supply, energy demand

Author: Michael Kostmann

See also: 

Submitted: 26.10.2018

Input: 

- data: 100 consumer and 100 prosumer data sets containing electricity readings in 3-minute intervals (csv-files)

- predictions: 15-minute interval prediction of electricity consumption for every consumer forecasted with LASSO model (csv-file)

Output: 

- equilibrium price: the highest price which can still be served given the amounts offered by producers

- local energy market price: average of equilibrium price and maximum price weighted by kWh amounts traded at the respective price

- bid results for every market participate acting as consumer: 

- ask results for every market participate acting as producer: 

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMmarketSimulation/marketoutcome_pred_balanced.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMmarketSimulation/marketoutcome_pred_oversupply.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMmarketSimulation/marketoutcome_pred_undersupply.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMmarketSimulation/marketoutcome_true_balanced.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMmarketSimulation/marketoutcome_true_oversupply.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMmarketSimulation/marketoutcome_true_undersupply.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMmarketSimulation/producers_all.jpg" alt="Image" />
</div>

