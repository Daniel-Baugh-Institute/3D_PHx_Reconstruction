%% Justin Melunis, PhD
% Thomas Jefferson University

function [Sinu_both,Sinu_us,img_us] = Seg_Sinu_1_Pro(Path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[c4] = Import_Tiff_3d(Path,'c4.tif'); %
img4 = imgaussfilt3(c4,[50 50 10]);
img_us = c4 - img4;
img_us(img_us<0) = 0;
img_us = RescaleIm(img_us);
BW = adaptthresh(img_us,'NeighborhoodSize',[101 101 11]);
Sinu_us=img_us>BW;
Sinu_us = bwareaopen(Sinu_us,1000);

img=imgaussfilt3(c4,3) - img4;
img(img<0)=0;
img=RescaleIm(img);
BW = adaptthresh(img,'NeighborhoodSize',[101 101 11]);
Sinu=img>BW;

Sinu_both = imclose(Sinu & Sinu_us,strel('sphere',5));
Sinu_both = imopen(Sinu_both,strel('sphere',3));
end

