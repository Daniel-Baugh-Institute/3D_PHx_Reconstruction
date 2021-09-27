%% Justin Melunis, PhD
% Thomas Jefferson University

function [Bile] = Seg_Bile_1(c2,Sinu,g2)

img_b = c2;
img_b(Sinu)=g2(Sinu);
img_b = imgaussfilt3(img_b,3) - imgaussfilt3(img_b,[50 50 10]);
img_b(img_b<0)=0;
img_b = RescaleIm(img_b);
BW = adaptthresh(img_b,'NeighborhoodSize',[101 101 11]);
Bile = img_b > BW;
Bile = imclose(Bile,ones(3,3));
end

