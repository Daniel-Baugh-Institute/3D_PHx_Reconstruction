%% Justin Melunis, PhD
% Thomas Jefferson University

function Gather_Sinu_Nuc_Pro_Stats(Path,res)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    res = [0.621 0.621 0.54];
end

Nuc = Import_Tiff_3d(Path,'Sinu_Nuclei_Seg.tif');
c2 = Import_Tiff_3d(Path,'c2.tif');


BW = bwlabeln(Nuc>0);
R = regionprops3(BW,'Volume','VoxelIdxList','Centroid');
CV_X = -1*ones(size(R,1),1); CV_Y = CV_X; CV_Z = CV_X; D_CV = CV_X; 
PV_X = CV_X; PV_Y = CV_X; PV_Z = CV_X; D_PV = D_CV;
c1_Mean = CV_X; c1_Median = CV_X; c1_Center = CV_X; c1_G_Mean = CV_X; c1_G_Median = CV_X; c1_G_Center = CV_X;
c2_Mean = CV_X; c2_Median = CV_X; c2_Center = CV_X; c2_G_Mean = CV_X; c2_G_Median = CV_X; c2_G_Center = CV_X; 

c2_G = c2 - imgaussfilt3(c2,25);
c2_G(c2_G<0) = 0;
c2_G = RescaleIm(c2_G);
for i = 1:size(R,1)
    c2_Mean(i) = mean(c2(BW == i));
    c2_Median(i) = median(c2(BW == i));
    c2_Center(i) = c2(round(R.Centroid(i,2)), round(R.Centroid(i,1)),round(R.Centroid(i,3)));
    c2_G_Mean(i) = mean(c2_G(BW == i));
    c2_G_Median(i) = median(c2_G(BW == i));
    c2_G_Center(i) = c2_G(round(R.Centroid(i,2)), round(R.Centroid(i,1)),round(R.Centroid(i,3)));
end
headers = strsplit('Nuclei#,Defined_Voxel_Count,Center_X,Center_Y,Center_Z,D_CV,D_PV,C1_Mean,C1_Median,C1_G_Mean,C1_G_Median,C2_Mean,C2_Median,C2_G_Mean,C2_G_Median',',');
Num = [1:1:size(R,1)]';
Data = [Num,R.Volume(:,1),R.Centroid(:,2)*res(2),R.Centroid(:,1)*res(1),R.Centroid(:,3)*res(3),...
    D_CV,D_PV,c1_Mean,c1_Median,c1_G_Mean,c1_G_Median,c2_Mean,c2_Median,c2_G_Mean,c2_G_Median];

csvwrite(fullfile(Path,'Sinu_Nuclei_Stats'),Data);