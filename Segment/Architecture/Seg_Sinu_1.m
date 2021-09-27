%% Justin Melunis, PhD
% Thomas Jefferson University

function [Sinu,Sinu2,img4,c2,g2] = Seg_Sinu_1(path)

%% Substact background noise and rescale

%C2
[c2] = Import_Tiff_3d(path,'c2.tif'); %
g2=imgaussfilt3(c2,[50 50 10]);
img2=c2 - g2;
img2(img2<0)=0;
img2=RescaleIm(img2);

%c4
[c4] = Import_Tiff_3d(path,'c4.tif'); %
img4=imgaussfilt3(c4,[50 50 10]);
img4=c4 - img4;
img4(img4<0)=0;
img4=RescaleIm(img4);

%Removing potential sinusoids from the bile/sinusoid image
img = img2 - img4; % This will only leave spots which were higher than the background 
%and c4 (aka Bile and some noise).
img(img<0) = 0;

%Removing the bile and noise from c2
img= img2 - img; %This will leave only the potential sinusoids
img(img<0)=0;
img = RescaleIm(img);

%Segmenting unsmoothed image
BW = adaptthresh(img,'NeighborhoodSize',[101 101 11]);
Sinu=img>BW;  %%Unsmoothed image passes threshold

%Segmenting smoothed image
g=imgaussfilt3(img,3);
BW = adaptthresh(g,'NeighborhoodSize',[101 101 11]);
Sinu2=g>BW;  %%Smoothed image passes threshold
Sinu2 = bwareaopen(Sinu2,1000);

%Requiring any additional structure to pass on smooth and unsmoothed images
Sinu = Sinu & Sinu2;%This will be the parts that pass threshold on smoothed
%and unsmoothed images (this process of requiring both will remove the salt 
%and pepper noise from the unsmoothed segmentation)
Sinu = imclose(Sinu,strel('sphere',3));
Sinu = imclose(Sinu,ones(3,3));
end
