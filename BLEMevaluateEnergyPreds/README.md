<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: BLEMevaluateEnergyPreds

Published in: Forecasting in blockchain-based smart grids: Testing a prerequisite for the implementation of local energy markets

Description: Generates graphs and tables to evaluate prediction performance of naive predictor, LASSO, and LSTM models.

Keywords: mean absolute error, MAE, mean absolute percentage error, MAPE, root mean squared error, RMSE, normalised root mean squared error, NRMSE, mean absolute scaled error, MASE, heatmap, boxplot, error analysis, prediction accuracy, model performance, energy prediction, average performance

Author: Michael Kostmann

See also: 
- BLEMdataGlimpse
- BLEMdescStatEnergyData
- BLEMevaluateMarketSim
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

Datafile: 
- 100 consumer datasets (named "consumer-00000xxx.csv")
- 100 prosumer datasets (named "producer-00000xxx.csv")
- consumer predictions:
- naive_predictions.csv
- LASSO_predictions.csv
- LSTM_predictions.csv
- prosumer predictions
- naive_predictions.csv
- LASSO_predictions.csv
- LSTM_predictions.csv

Input: true consumption and production data and predicted consumption and production data

Output: 
- boxplots and heatmaps of naive, LASSO, and LSTM model performance according to MAE, MAPE, MASE, RMSE, and NRMSE on 88 consumer data sets
- boxplots and heatmaps of naive, LASSO, and LSTM model performance according to MAE, MASE, and RMSE on 12 prosumer data sets
- tables summarising the model performance across all consumer and prosumer data sets

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c027_squarederrors.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_boxplot_MAE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_boxplot_MAPE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_boxplot_MASE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_boxplot_NRMSE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_boxplot_RMSE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_heatmap_MAE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_heatmap_MAPE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_heatmap_MASE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_heatmap_MdAPE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_heatmap_NRMSE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_heatmap_NRMdSE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/c_heatmap_RMSE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/p_boxplot_MAE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/p_boxplot_MASE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/p_boxplot_RMSE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/p_heatmap_MAE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/p_heatmap_MASE.jpg" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/BLEM/master/BLEMevaluateEnergyPreds/p_heatmap_RMSE.jpg" alt="Image" />
</div>

