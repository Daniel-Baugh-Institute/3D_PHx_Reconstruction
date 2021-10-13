# 3D_PHx_Reconstruction

Title: Mouse Liver Microarchitecture 3D reconstruction in MATLAB
Author: Justin Melunis, Ph.D.
Date: tbd

About: This repository provides the code to recreate the analysis described in the our forthcoming paper. 

To run:

This repository is designed to create a GUI application within the program MATLAB 2018b.
The application analyzes images obtained from confocal microscopy z-stacks, stained according to the protocol described in Hammad et al, 2014.
The images analyzed in our work can be found in the folder labeled "IFADO_PHx_stacks".

To run the application and replicate our analysis, create a clone of this repository.
The GUI app runs through the use of the BioFormats Toolbox, which can be viewed and downloaded here: https://www.openmicroscopy.org/bio-formats/downloads/

Using MATLAB 2018b (or later version), first add the executible jar file, "bioformats_package.jar" to the path. This file is downloaded within the BioFormats Toolbox, and must be added to the javaclasspath in MATLAB. 

>> javaclasspath('C:/Path_to/bioformats_package.jar')

To start the GUI, open the "Liver_Segmentation_App.mlapp".

For instructions on how to navigate the GUI app, please refer to supplementary files of our paper. 


References: 
1.) Hammad, Seddik, Stefan Hoehme, Adrian Friebel, Iris Von Recklinghausen, Amnah Othman, Brigitte Begher-Tibbe, Raymond Reif et al. "Protocols for staining of bile canalicular and sinusoidal networks of human, mouse and pig livers, three-dimensional reconstruction and quantification of tissue microarchitecture by image processing and analysis." Archives of toxicology 88, no. 5 (2014): 1161-1183.
