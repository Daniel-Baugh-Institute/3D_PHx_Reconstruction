%% Justin Melunis, PhD
% Thomas Jefferson University

function [Sinu,PV_Mask,CV_Mask] = Seg_Sinu_2(Sinu,Sinu2,PV_Mask,CV_Mask,Path_out)

a = CV_Mask | PV_Mask | Sinu2;
a = imclose(a,strel('sphere',3));
a = imfill(a,'holes');
Skel = Skeleton3D(a);
Write_Tiff_3d(Skel,'Net_Skeleton',Path_out,'binary')

Skel(CV_Mask | PV_Mask)=0;
Write_Tiff_3d(Skel,'Sinu_Skeleton',Path_out,'binary')

%Use the skeleton to refine the segmentation
s1 = imdilate(Skel,strel('sphere',4));
s2 = imdilate(Skel,strel('sphere',16));
s1 = s1 & Sinu2;
s2 = s2 & Sinu;
Sinu = s1 | s2;
Sinu = imclose(Sinu,strel('sphere',3));
Sinu = imopen((Sinu | CV_Mask | PV_Mask),strel('sphere',3)) & Sinu;
Sinu = bwareaopen(Sinu,1000);
% Sinu = imclose(Sinu,strel('sphere',5));

%%%Clean up Sinusoid/CV/PV connections
a = imclose(CV_Mask|Sinu,strel('sphere',5));
b = imclose(Sinu,strel('sphere',5));
CV_Mask = CV_Mask | (a-b);
CV_Mask(isnan(CV_Mask)) = 0;
% %PV
a = imclose(PV_Mask|Sinu,strel('sphere',5));
PV_Mask = PV_Mask | (a-b);
PV_Mask(isnan(PV_Mask)) = 0;

%Save Results
Write_Tiff_3d(Sinu,'Sinusoids',Path_out,'binary')
Write_Tiff_3d(CV_Mask,'CV_Mask',Path_out,'binary')
Write_Tiff_3d(PV_Mask,'PV_Mask',Path_out,'binary')
end

