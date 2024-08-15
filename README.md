# Seagrass-Monitoring-with-Sentinel-2-Imagery-and-GEE-Classifiers
Here the seagrass Z.noltii and Z.marina species in the North-Frisian Wadden Sea were analyzed by processing Sentinel-2 imagery from 2018 to 2023. 
Athmospherically corrected images were classified in Google Earth Engine by applying various machine learning classifiers. 
The spatial distribution of the resulting data were analyzed by multinominal logistic regression analysis. 
Multiple plots were created to visualize the results.

Note that the code represents the final working-stage and was **not** adapted to be user-friendly besides some very sparse comments here and there.

### Files contained in this repo

* Gee Scripts
  * File 1: Preprocesses the image, calculates relevant indeces and prepaires sample data for training and testing
  * File 2: Performes the classification with five different GEE built-in classifiers
  * File 3: Computes a majority voting of the other classifiers to reduce biases

* Python Scripts
  * File 1: Converts the classified raster images to area data and plots the seagrass time-series
  * File 2: Computes statistical values describing the overall accuracy of the different classifiers
  * File 3: Plots average confusion matrices of all classifiers
  * File 4: Plots the geomorphological factors that seam to influence the seagrasses spatial distribution
  * File 5: Plots the Time-Series of factors that seam to influence the seagrasses temporal distribution

* R Script
  * R was used to compute simple logistic and multinominal regression on the classified data to assess the importance of geomorpholocial factors on seagrass presence or absence. 
