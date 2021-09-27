function [outputArg1,outputArg2] = Seg_Parallel(path)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

spmd
    if labindex == 2
        c = import3d_tiff(path,'c2.tif'); %c2
        g=imgaussfilt3(c,[50 50 10]);
        img=c - g;
        img(img<0)=0;
        img = RescaleIm(img);
    elseif labindex == 3
        c = import3d_tiff(path,'c3.tif'); %GS
        c = imgaussfilt3(c,3); %Smooth to eliminate noise
        c = c > graythresh(c);
    elseif labindex == 4
        c = import3d_tiff(path,'c4.tif'); %c4
        img=imgaussfilt3(c,[50 50 10]);
        img=c - img;
        img(img<0)=0;
        img = RescaleIm(img);
    end
end

img2 = labSendReceive(rcvWkrIdx,srcWkrIdx,dataSent)