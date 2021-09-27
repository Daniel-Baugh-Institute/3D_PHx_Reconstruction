%% Justin Melunis, PhD
% Thomas Jefferson University

function [Comp] = Create_Composite(Path)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
CV_Mask = Import_Tiff_3d(Path,'CV_Mask.tif');
CV_Mask(isnan(CV_Mask)) = 0;
PV_Mask = Import_Tiff_3d(Path,'PV_Mask.tif');
PV_Mask(isnan(PV_Mask)) = 0;
Sinusoids = Import_Tiff_3d(Path,'Sinusoids.tif');
Bile = Import_Tiff_3d(Path,'Bile.tif');

Comp = im2uint8(zeros(size(CV_Mask)));
Comp(CV_Mask==1) = 1;
Comp(PV_Mask==1) = 2;
Comp(Sinusoids==1) = 3;
Comp(Bile==1) = 4;
Write_Tiff_3d(Comp,'Composite',Path,'uint8')
end

