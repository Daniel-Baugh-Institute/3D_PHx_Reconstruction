%% Justin Melunis, PhD
% Thomas Jefferson University

function Seg_Nuclei(Path,Path_out)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    Path_out = Path;
end

[c1] = Import_Tiff_3d(Path,'c1.tif');
[c3] = Import_Tiff_3d(Path,'c3.tif');
[CV_Mask] = Import_Tiff_3d(Path,'CV_Mask.tif');
CV_Mask(isnan(CV_Mask)) = 0;
[PV_Mask] = Import_Tiff_3d(Path,'PV_Mask.tif');
PV_Mask(isnan(PV_Mask)) = 0;
[Bile] = Import_Tiff_3d(Path,'Bile.tif');
[Sinusoids] = Import_Tiff_3d(Path,'Sinusoids.tif');
DS = (CV_Mask|Sinusoids|Bile|PV_Mask);

%%
c = c1 - c3;
c(c<0) = 0;
c = RescaleIm(c);
Nuclei = LoG_Blob_Detector_3d(c);
Nuc2 = Nuclei;
Nuc2(~Sinusoids) = 0;
Nuclei(DS) = 0;
%% Segment Nuclei
L = bwlabeln(Nuclei);
Write_Tiff_3d(L,'Hepa_Nuclei_Seg',Path_out,'uint16')
Write_Tiff_3d(L > 0,'Hepa_Nuclei',Path_out,'binary')
Write_Tiff_3d(Nuc2,'Sinu_Nuclei_Seg',Path_out,'binary')
end

