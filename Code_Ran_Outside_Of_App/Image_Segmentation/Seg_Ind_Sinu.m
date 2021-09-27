function Seg_Ind_Sinu(Path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[Sinu] = Import_Tiff_3d(Path,'Sinusoids.tif');
Skel = Import_Tiff_3d(Path,'Sinu_Skeleton.tif') > 0;
[~,node,link] = Skel2Graph3D(Skel,12);

end

