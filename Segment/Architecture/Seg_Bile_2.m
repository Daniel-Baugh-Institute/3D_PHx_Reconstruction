%% Justin Melunis, PhD
% Thomas Jefferson University

function [Bile] = Seg_Bile_2(Bile,PV_Mask,CV_Mask,Sinu,Path_out)
Bile(CV_Mask | PV_Mask | Sinu) = 0;
Bile = bwareaopen(Bile,1000);
Bile = Skeleton3D(Bile);
Write_Tiff_3d(Bile,'Bile_Skeleton',Path_out,'binary')

%%%SET RESTRICTIONS ON SKELETON
Bile = imdilate(Bile,strel('sphere',2));
Bile = imclose(Bile,strel('sphere',3));
Write_Tiff_3d(Bile,'Bile',Path_out,'binary')
end

