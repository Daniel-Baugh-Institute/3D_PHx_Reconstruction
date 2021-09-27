%% Justin Melunis, PhD
% Thomas Jefferson University

function [V,GS] = Seg_Void(img4,Bile,path)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[c3] = Import_Tiff_3d(path,'c3.tif'); %GS
c3 = imgaussfilt3(c3,3); %Smooth to eliminate noise
c3 = c3 > graythresh(c3);
c3 = imclose(c3,strel('cube',10));
c3 = bwareaopen(c3,10000);

[c1] = Import_Tiff_3d(path,'c1.tif'); %GS
c1 = c1 - imgaussfilt3(c1,20); %Smooth to eliminate noise
c1 = c1 > graythresh(c1);

c4g=imgaussfilt3(img4,3);
BW = adaptthresh(c4g,'NeighborhoodSize',[101 101 11]);
c4t = c4g > BW;
c4t = imclose(c4t, strel('sphere',5));

%%%%% Finding areas of void
Web = c4t | Bile | c1;
Web_pix = imclose(Web,strel('cube',20));

% Segmenting the web
Seg = bwconncomp(Web_pix); %Segment web by connected components
GS = find(c3(:)==1);%Find the indexes of the GS stained area

for i=1: Seg.NumObjects %Keep only web areas which overlap some form of GS staining
    a = intersect(GS,Seg.PixelIdxList{i});
    if numel(a) < 10
        Web_pix(Seg.PixelIdxList{i})=0;
    end
end
V = ~c3 & ~Web_pix; %Area that is void
end

