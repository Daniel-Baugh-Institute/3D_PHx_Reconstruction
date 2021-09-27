%% Justin Melunis, PhD
% Thomas Jefferson University

function Gather_Volume_Stats(Path,res)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin<2
    res = [0.621 0.621 0.54];
end
if exist(fullfile(Path,'Composite.tif'),'file') ==2  
    [Comp] = Import_Tiff_3d(Path,'Composite.tif','uint8');
else
    [Comp] = Create_Composite(Path);
end
Vol = numel(Comp(:));
Vol_CV = sum(Comp(:)==1);
Vol_PV = sum(Comp(:)==2);
Vol_Sinu = sum(Comp(:)==3);
Vol_Bile = sum(Comp(:)==4);
Vol_Cell = sum(Comp(:)==0);
t_vol = Vol*res(1)*res(2)*res(3);
p_cv = Vol_CV/Vol;
p_pv = Vol_PV/Vol;
p_s = Vol_Sinu/Vol;
p_b = Vol_Bile/Vol;
p_c = Vol_Cell/Vol;
aVol = Vol - Vol_CV - Vol_PV;
ap_s = Vol_Sinu/aVol;
ap_b = Vol_Bile/aVol;
ap_c = Vol_Cell/aVol;
labels = strsplit('total_volume,percent CV,percent PV,percent Sinu,percent Bile,percent cell,adjusted percent Sinu,adjusted percent Bile,adjusted percent cell',',');
xlswrite(fullfile(Path,'Volume_Data_Labels'),labels,'Sheet1','A1');
csvwrite(fullfile(Path,'Volume_Data'),[t_vol,p_cv,p_pv,p_s,p_b,p_c,ap_s,ap_b,ap_c])


